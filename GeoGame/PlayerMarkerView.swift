//
//  PlayerAnnotationView.swift
//  GeoGame
//
//  Created by Anastasia on 5/26/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation
import MapKit

class PlayerMarkerView: MKMarkerAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let playerAnnotation = newValue as? PlayerAnnotation else { return }
            canShowCallout = true
            
            markerTintColor = playerAnnotation.markerTintColor
            glyphText = "\(playerAnnotation.power)"
        }
    }
}
