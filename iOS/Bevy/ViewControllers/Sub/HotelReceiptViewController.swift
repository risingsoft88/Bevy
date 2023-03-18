//
//  HotelReceiptViewController.swift
//  Bevy
//
//  Created by macOS on 7/24/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class HotelReceiptViewController: BaseSubViewController {

    @IBOutlet weak var btnUnlock: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        btnUnlock.layer.cornerRadius = 10
    }

    @IBAction func unlockClicked(_ sender: Any) {
    }

}
