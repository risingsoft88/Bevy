//
//  SocialHelpViewController.swift
//  Bevy
//
//  Created by macOS on 7/9/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class SocialHelpViewController: BaseSubViewController {

    @IBOutlet weak var viewAlert: UIView!
    @IBOutlet weak var editMessage: UITextView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnBack: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewAlert.isHidden = true
        btnSend.layer.cornerRadius = 10
        btnBack.layer.cornerRadius = 10
        editMessage.layer.cornerRadius = 10
        editMessage.layer.borderWidth = 1
        editMessage.layer.borderColor = UIColor.white.cgColor
    }

    @IBAction func sendClicked(_ sender: Any) {
        viewAlert.isHidden = false
    }

    @IBAction func msgBackClicked(_ sender: Any) {
        viewAlert.isHidden = true
    }

}
