//
//  FlightsSearchViewController.swift
//  Bevy
//
//  Created by macOS on 6/29/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class FlightsSearchViewController: BaseSubViewController {

    @IBOutlet weak var btnBookFlight: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        btnBookFlight.layer.cornerRadius = 5
    }

}
