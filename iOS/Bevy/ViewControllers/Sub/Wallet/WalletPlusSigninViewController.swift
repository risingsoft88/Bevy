//
//  WalletPlusSigninViewController.swift
//  Bevy
//
//  Created by macOS on 7/9/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class WalletPlusSigninViewController: BaseSubViewController {
    @IBOutlet weak var viewWrapper: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var editEmail: UITextField!
    @IBOutlet weak var editPassword: UITextField!
    @IBOutlet weak var btnSignin: UIButton!

    var hidePassword = true

    override func viewDidLoad() {
        super.viewDidLoad()

        btnSignin.layer.cornerRadius = 10
        editPassword.isSecureTextEntry = hidePassword
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        viewWrapper.topRoundedView()
        viewEmail.addBottomBorderWithColor(color: UIColor.white, width: 2)
        viewPassword.addBottomBorderWithColor(color: UIColor.white, width: 2)
    }

    @IBAction func showPasswordClicked(_ sender: Any) {
        hidePassword = !hidePassword
        editPassword.isSecureTextEntry = hidePassword
    }

    @IBAction func signinClicked(_ sender: Any) {
    }

    @IBAction func forgotClicked(_ sender: Any) {
    }

    @IBAction func facebookClicked(_ sender: Any) {
    }

    @IBAction func twitterClicked(_ sender: Any) {
    }

    @IBAction func googleClicked(_ sender: Any) {
    }

    @IBAction func appleClicked(_ sender: Any) {
    }

    @IBAction func signupClicked(_ sender: Any) {
    }
}
