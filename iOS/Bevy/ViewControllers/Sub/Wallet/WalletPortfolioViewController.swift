//
//  WalletPortfolioViewController.swift
//  Bevy
//
//  Created by macOS on 7/24/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class WalletPortfolioViewController: BaseSubViewController {

    @IBOutlet weak var btnCashOut: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        btnCashOut.layer.cornerRadius = 10
    }

    @IBAction func cashoutClicked(_ sender: Any) {
        let viewController = R.storyboard.wallet().instantiateViewController(withIdentifier: "PropertyProfileViewController") as! PropertyProfileViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }

}
