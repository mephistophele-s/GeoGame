//
//  PlayerAnnotation.swift
//  GeoGame
//
//  Created by Anastasia on 5/26/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation
import MapKit

class PlayerAnnotation: NSObject, MKAnnotation {
    
    let team: Team
    let name: String
    let power: Int
    let coordinate: CLLocationCoordinate2D
    
    init(player: Player) {
        self.team = player.team
        self.name = player.name
        self.power = player.power
        self.coordinate = player.location
        
        super.init()
    }
    
    init(team: Team, name: String, power: Int, coordinate: CLLocationCoordinate2D) {
        self.team = team
        self.name = name
        self.power = power
        self.coordinate = coordinate
        
        super.init()
    }
    
    var markerTintColor: UIColor  {
        switch team {
        case .green :
            return .blue
        case .red:
            return .magenta
        }
    }
    
    var title: String? {
        return name
    }
}

