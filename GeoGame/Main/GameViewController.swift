//
//  MapViewController.swift
//  GeoGame
//
//  Created by Anastasia on 5/15/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit
import CoreLocation
import Pulsator
import GoogleMaps

class GameViewController: UIViewController {
    
    private let contentView = GameView()

    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 600
    
    var timer: Timer?
    
    let engine = GameEngine()
    
    var markers: [PlayerMapMarker] = []
    
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialLocation()
        contentView.delegate = self
        contentView.mapView.delegate = self
        contentView.mapView.setMinZoom(16, maxZoom: 16)
        setupLocationManager()
        updatePlayers()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.moveMarkers()
        }
    }
    
    private func setupLocationManager() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
    }
    
    func updatePlayers() {
        engine.onPlayersUpdate { players in
            self.draw(players: players)
        }
    }
    
    func draw(players: [Player]) {
        players.forEach { player in
            
            let marker = PlayerMapMarker(player: player)
            let markerView = PlayerMapMarkerView(player: player)
            
            marker.iconView = markerView
            marker.tracksViewChanges = true
            marker.map = contentView.mapView
            
            markers.append(marker)
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let camera = GMSCameraPosition(target: location.coordinate, zoom: 16)
        contentView.mapView.animate(to: camera)
    }
}

extension GameViewController: CLLocationManagerDelegate {
    
    func makePlayer(with location: CLLocationCoordinate2D) -> Player {
        return Player(team: .red, name: "Looooooola", id: 6, location: location, power: 50)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else { return }
        
        let mockedLocation = CLLocation(latitude: 50.442029, longitude: 30.4410228)
        centerMapOnLocation(location: mockedLocation)
        
        let player = makePlayer(with: mockedLocation.coordinate)
        engine.synchronize(player: player)
    }

    private func setupInitialLocation() {
        let mockedLocation = CLLocation(latitude: 50.442029, longitude: 30.4410228)
        centerMapOnLocation(location: mockedLocation)
    }
}

extension GameViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let playerMarker = marker as? PlayerMapMarker,
            let markerView = playerMarker.iconView as? PlayerMapMarkerView
        else { return false }
     
        markerView.togglePulsator()
        return true
    }
}

extension GameViewController {
    
    private func moveMarkers() {
        for marker in markers {
            var position = marker.position
            
            let topMove = Bool.random()
            let rightMove = Bool.random()
            
            if topMove {
                position.longitude -= 0.002
            } else {
                position.longitude += 0.002
            }
            
            if rightMove {
                position.latitude += 0.0001
            } else {
                position.latitude -= 0.0001
            }
            
            marker.position = position
        }
    }
}

extension GameViewController: GameViewDelegate {
    func didTapPauseButton() {
        contentView.toggleTimer()
    }
    
    func didTapAttackButton() {
        let marker = markers[0]
        guard let markerView = marker.iconView as? PlayerMapMarkerView else { return }
        contentView.mapView.camera = GMSCameraPosition(target: marker.position, zoom: 16)
        
        let closest = closestMarker(to: marker)
        guard let closestView = closest.iconView as? PlayerMapMarkerView else { return }
        
        closestView.togglePulsator()
        markerView.togglePulsator()
    }
    
    private func closestMarker(to marker: PlayerMapMarker) -> PlayerMapMarker {
        let filtered = markers.filter { $0.player.team != marker.player.team }
        let closest = filtered.sorted (by: { (m1, m2) -> Bool in
            return m1.position.distance(to: marker.position) < m2.position.distance(to: marker.position)
        })[0]
        return closest
    }
}
