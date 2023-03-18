//
//  FindRideViewController.swift
//  Bevy
//
//  Created by macOS on 7/24/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class FindRideViewController: BaseSubViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func scheduleClicked(_ sender: Any) {
        let viewController = R.storyboard.sub().instantiateViewController(withIdentifier: "DriverSearchViewController") as! DriverSearchViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }

}
