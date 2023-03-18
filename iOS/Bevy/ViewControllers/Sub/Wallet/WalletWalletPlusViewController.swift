//
//  WalletWalletPlusViewController.swift
//  Bevy
//
//  Created by macOS on 7/1/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class WalletWalletPlusViewController: BaseSubViewController {

    @IBOutlet weak var btnSignin: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        btnSignin.layer.cornerRadius = 10
    }

    @IBAction func signinClicked(_ sender: Any) {
        let vc = R.storyboard.wallet().instantiateViewController(withIdentifier: "WalletPlusSigninViewController") as! WalletPlusSigninViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
