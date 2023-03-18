//
//  HotelDetailViewController.swift
//  Bevy
//
//  Created by macOS on 7/9/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class HotelDetailViewController: BaseSubViewController {

    @IBOutlet weak var btnBook: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        btnBook.layer.cornerRadius = 10
    }

    @IBAction func bookClicked(_ sender: Any) {
        let viewController = R.storyboard.sub().instantiateViewController(withIdentifier: "HotelCheckoutViewController") as! HotelCheckoutViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }

}
