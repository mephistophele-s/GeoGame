//
//  GameView.swift
//  GeoGame
//
//  Created by Inquisitor on 6/9/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit
import GoogleMaps
import Closures

protocol GameViewDelegate: class {
    func didTapPauseButton()
}

class GameView: UIView {

    let mapView = GMSMapView()
    private let pauseButton = UIButton()
    private let pauseView = PauseView()

    weak var delegate: GameViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        addSubview(pauseButton)
        pauseButton.onTap { [weak self] in self?.delegate?.didTapPauseButton() }
        pauseButton.setImage(UIImage(named: "pause-icon"), for: .normal)
        pauseButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(60)
            $0.leading.equalToSuperview().offset(20)
            $0.size.equalTo(60)
        }
    
        addSubview(pauseView)
        pauseView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(160)
        }
    }
    
    func toggleTimer() {
        pauseView.toggleTimer()
    }
}
