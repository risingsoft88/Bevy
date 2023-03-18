//
//  SocialCommentsViewController.swift
//  Bevy
//
//  Created by macOS on 8/4/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class SocialCommentsViewController: BaseSubViewController {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var viewInputWrapper: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewInputWrapper.layer.cornerRadius = viewInputWrapper.frame.size.height / 2

        Utils.loadAvatar(imgAvatar)
    }

    @IBAction func sendMessageClicked(_ sender: Any) {
    }

}
