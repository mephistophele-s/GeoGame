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
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 600
    
    var timer: Timer?
    
    let engine = GameEngine()
    
    var markers: [PlayerMapMarker] = []

    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
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
            marker.map = mapView
            
            markers.append(marker)
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let camera = GMSCameraPosition(target: location.coordinate, zoom: 16)
        mapView.animate(to: camera)
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
