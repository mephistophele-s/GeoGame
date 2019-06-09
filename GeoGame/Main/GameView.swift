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
import GTProgressBar

protocol GameViewDelegate: class {
    func didTapPauseButton()
    func didTapAttackButton()
}

class GameView: UIView {

    let mapView = GMSMapView()
    private let pauseButton = UIButton()
    private let attackButton = UIButton()
    private let pauseView = PauseView()
    private let progressBar = GTProgressBar()

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
    
        addSubview(attackButton)
        attackButton.setImage(UIImage(named: "attack-icon"), for: .normal)
        attackButton.onTap { [weak self] in self?.delegate?.didTapAttackButton() }
        attackButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(36)
            $0.bottom.equalToSuperview().inset(60)
            $0.size.equalTo(60)
        }
        
        addSubview(pauseView)
        pauseView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(160)
        }
        
        addSubview(progressBar)
        progressBar.orientation = .vertical
        progressBar.labelPosition = .bottom
        progressBar.barBorderColor = UIColor(red:0.35, green:0.80, blue:0.36, alpha:1.0)
        progressBar.barFillColor = UIColor(red:0.35, green:0.80, blue:0.36, alpha:1.0)
        progressBar.barBackgroundColor = UIColor(red:0.77, green:0.93, blue:0.78, alpha:1.0)
        progressBar.progress = 0.9
        progressBar.snp.makeConstraints {
            $0.right.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(60)
            $0.height.equalToSuperview().multipliedBy(0.7)
            $0.width.equalTo(16)
        }
    }
    
    func toggleTimer() {
        pauseView.toggleTimer()
    }
}
