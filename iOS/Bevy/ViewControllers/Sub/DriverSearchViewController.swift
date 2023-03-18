//
//  DriverSearchViewController.swift
//  Bevy
//
//  Created by macOS on 7/24/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class DriverSearchViewController: BaseSubViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func confirmClicked(_ sender: Any) {
        let viewController = R.storyboard.sub().instantiateViewController(withIdentifier: "TravelRideshareViewController") as! TravelRideshareViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }

}
