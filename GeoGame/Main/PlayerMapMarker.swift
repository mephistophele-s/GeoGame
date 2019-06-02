//
//  PlayerMapMarker.swift
//  GeoGame
//
//  Created by Inquisitor on 6/2/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit
import GoogleMaps
import SnapKit
import Pulsator

class PlayerMapMarker: GMSMarker {
    
    let player: Player
    
    init(player: Player) {
        self.player = player
        super.init()
        self.position = player.location
    }
}

class PlayerMapMarkerView: UIView {
    
    let player: Player
    
    private let infoLabel = UILabel()
    private let pulsator = Pulsator()
    
    private let infoView = UIView()
    
    init(player: Player) {
        self.player = player
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .clear
        
        addSubview(infoView)
        let bgColor: UIColor = player.team == .green ? .blue : .magenta
        infoView.backgroundColor = bgColor.withAlphaComponent(0.2)
        infoView.layer.borderColor = bgColor.cgColor
        infoView.layer.borderWidth = 3
        infoView.layer.cornerRadius = 20
        infoView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(40)
        }
       
        infoView.addSubview(infoLabel)
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 2
        infoLabel.font = UIFont.systemFont(ofSize: 10)
        infoLabel.text = "\(player.name) \n\(player.power)"
        infoLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        layer.addSublayer(pulsator)
        pulsator.radius = 50
        pulsator.numPulse = 3
        pulsator.backgroundColor = bgColor.cgColor
        pulsator.frame = CGRect(x: 50, y: 50, width: 0, height: 0)
    }
    
    func togglePulsator() {
        pulsator.isPulsating ? pulsator.stop() : pulsator.start()
    }
}
