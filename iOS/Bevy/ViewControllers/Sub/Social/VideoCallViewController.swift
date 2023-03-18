//
//  VideoCallViewController.swift
//  Bevy
//
//  Created by macOS on 8/12/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class VideoCallViewController: BaseSubViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func closeClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
