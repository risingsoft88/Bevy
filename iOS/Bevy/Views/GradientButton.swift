//
//  GradientButton.swift
//  Bevy
//
//  Created by macOS on 6/19/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class GradientButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = self.bounds
        l.colors = [UIColor(rgb: 0xBA3D35).cgColor, UIColor(rgb: 0x955954).cgColor]
        l.startPoint = CGPoint(x: 0.7, y: 0.5)
        l.endPoint = CGPoint(x: 1, y: 0.5)
        l.cornerRadius = self.bounds.height/2
        layer.insertSublayer(l, at: 0)
        return l
    } ()
}
