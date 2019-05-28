//
//  MapViewController.swift
//  GeoGame
//
//  Created by Anastasia on 5/15/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class GameViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 600
    
    let engine = GameEngine()

    @IBOutlet weak var map: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        map.register(PlayerMarkerView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        map.delegate = self
        
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
        
        updatePlayers()
    }
    
    func updatePlayers() {
        engine.onPlayersUpdate { players in
            self.draw(players: players)
            
        }
    }
    
    var timer: Timer?
    
    func draw(players: [Player]) {
        players.forEach { player in
            
            let circleAnnotation = PlayerAnnotation(team: player.team, name: player.name, power: player.power, coordinate: player.location)
            map.addAnnotation(circleAnnotation)
//
//            let circle = PlayerCircle(center: player.location, radius: 5)
//            circle.player = player
//
//            let zoneCircle = ZoneCircle(center: player.location, radius: 50)
//            zoneCircle.player = player
//            map.addOverlay(zoneCircle)
            
            var zoneIsShown = true
            
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
               // circleAnnotation.coordinate = 
            }
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        map.setRegion(coordinateRegion, animated: true)
    }
}

class PlayerCircle: MKCircle {
    
    var player: Player?
}

class ZoneCircle: MKCircle {
    
    var player: Player?
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

extension GameViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? PlayerAnnotation else { return nil }
       
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = PlayerMarkerView(annotation: annotation, reuseIdentifier: identifier)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circle = overlay as? PlayerCircle, let player = circle.player {
            let circleRenderer = MKCircleRenderer(overlay: circle)
            circleRenderer.fillColor = player.team == .green ? UIColor(red: 0, green: 0, blue: 1, alpha: 1) : UIColor(red: 1, green: 0, blue: 0, alpha: 1)
            return circleRenderer
        }
        
        if let circle = overlay as? ZoneCircle, let player = circle.player {
            let circleRenderer = MKCircleRenderer(overlay: circle)
            let fillColor = player.team == .green ? UIColor(red: 0, green: 0, blue: 1, alpha: 0.2) : UIColor(red: 1, green: 0, blue: 0, alpha: 0.2)
            
            let strokeColor = player.team == .green ? UIColor(red: 0, green: 0, blue: 1, alpha: 1.0) : UIColor(red: 1, green: 0, blue: 0, alpha: 1.0)
            circleRenderer.fillColor = fillColor
            circleRenderer.strokeColor = strokeColor
            circleRenderer.lineWidth = 3.0
            return circleRenderer
        }
        
        return MKOverlayRenderer()
    }
}

class CustomPolyline: MKPolyline {
    
    var color = "#144eaa"
    var width: CGFloat = 4.0
}
