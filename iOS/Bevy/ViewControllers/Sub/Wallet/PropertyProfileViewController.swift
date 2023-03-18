//
//  PropertyProfileViewController.swift
//  Bevy
//
//  Created by macOS on 7/24/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class PropertyProfileViewController: BaseSubViewController {

    @IBOutlet weak var btnContactOwner: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        btnContactOwner.layer.cornerRadius = 10
    }

    @IBAction func contactownerClicked(_ sender: Any) {
    }

}
