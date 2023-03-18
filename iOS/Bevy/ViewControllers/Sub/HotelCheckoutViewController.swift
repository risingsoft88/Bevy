//
//  HotelCheckoutViewController.swift
//  Bevy
//
//  Created by macOS on 7/24/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class HotelCheckoutViewController: BaseSubViewController {

    @IBOutlet weak var btnPaynow: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        btnPaynow.layer.cornerRadius = 10
    }

    @IBAction func paynowClicked(_ sender: Any) {
        let viewController = R.storyboard.sub().instantiateViewController(withIdentifier: "HotelReceiptViewController") as! HotelReceiptViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }

}
