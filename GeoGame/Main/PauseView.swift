//
//  PauseView.swift
//  GeoGame
//
//  Created by Inquisitor on 6/9/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit

class PauseView: UIView {

    private let timelabel = UILabel()
    private var timer: Timer?
    private var pauseActiveTime = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 16
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        isHidden = true
        
        addSubview(timelabel)
        timelabel.text = "00:00"
        timelabel.font = .boldSystemFont(ofSize: 24)
        timelabel.textColor = .black
        timelabel.textAlignment = .center
        timelabel.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    func toggleTimer() {
        if timer?.isValid == true {
            timer?.invalidate()
            pauseActiveTime = 0
            timelabel.text = "00:00"
            isHidden = true
        } else {
            isHidden = false
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [unowned self] _ in
                self.pauseActiveTime += 1
                var text = "\(self.pauseActiveTime)"
                if text.count == 1 {
                    text = "0\(text)"
                }
                text = "00:\(text)"
                self.timelabel.text = text
            })
        }
    }
}
