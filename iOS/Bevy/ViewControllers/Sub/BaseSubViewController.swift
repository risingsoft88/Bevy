//
//  BaseSubViewController.swift
//  Bevy
//
//  Created by macOS on 6/29/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class BaseSubViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func backClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
