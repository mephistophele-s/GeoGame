//
//  Player.swift
//  GeoGame
//
//  Created by Anastasia on 5/22/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation
import CoreLocation

struct Player {
    
    let team: Team
    let name: String
    let id: Int
    
    let location: CLLocationCoordinate2D
    let power: Int
}

enum Team {
    
    case green, red
}

extension CLLocationCoordinate2D {
    
    func distance(to point: CLLocationCoordinate2D) -> Double {
        let a = (self.latitude - point.latitude) * (self.latitude - point.latitude)
        let b = (self.longitude - point.longitude) * (self.longitude - point.longitude)
        return sqrt(a + b)
    }
}
