//
//  WalletTransactionViewController.swift
//  Bevy
//
//  Created by macOS on 8/4/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class WalletTransactionViewController: BaseSubViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func viewMapClicked(_ sender: Any) {
        let vc = R.storyboard.wallet().instantiateViewController(withIdentifier: "WalletTransactionMapViewController") as! WalletTransactionMapViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

}
