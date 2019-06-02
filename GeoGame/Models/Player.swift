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
