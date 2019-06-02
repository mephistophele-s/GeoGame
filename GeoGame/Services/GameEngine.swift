//
//  GameEngine.swift
//  GeoGame
//
//  Created by Anastasia on 5/22/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import Foundation
import CoreLocation

class GameEngine {
    
    var timer: Timer?
    var me: Player?
    
    func synchronize(player: Player) {
        self.me = player
        print("sendMyLocation")
    }
    
    func onPlayersUpdate(with completion: @escaping ([Player]) -> Void) {
        print("requestGameData")
        
        let players = [Player(team: .green, name: "Lol", id: 1, location: CLLocationCoordinate2D(latitude:                    50.442029, longitude: 30.4410228), power: 50),
                       Player(team: .green, name: "Kek", id: 2, location: CLLocationCoordinate2D(latitude: 50.4434874, longitude: 30.438646), power: 50),
                       Player(team: .green, name: "Lal", id: 3, location: CLLocationCoordinate2D(latitude: 50.442170, longitude: 30.438605), power: 50),
                       Player(team: .red, name: "Meow", id: 4, location: CLLocationCoordinate2D(latitude: 50.440926, longitude: 30.440643), power: 50),
                       Player(team: .red, name: "Wuff", id: 5, location: CLLocationCoordinate2D(latitude: 50.440762, longitude: 30.443840), power: 50)]
        
        
//        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            completion(players)
//        }
    }
}
