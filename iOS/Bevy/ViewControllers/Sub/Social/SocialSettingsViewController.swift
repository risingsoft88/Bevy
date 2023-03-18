//
//  SocialSettingsViewController.swift
//  Bevy
//
//  Created by macOS on 8/4/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class SocialSettingsViewController: BaseSubViewController {

    @IBOutlet weak var viewNotification: UIView!
    @IBOutlet weak var viewLinkedAccount: UIView!
    @IBOutlet weak var viewSearchHistory: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let notificationTap = UITapGestureRecognizer(target: self, action: #selector(notificationClicked))
        viewNotification.isUserInteractionEnabled = true
        viewNotification.addGestureRecognizer(notificationTap)
    }

    @objc func notificationClicked() {
        let viewController = R.storyboard.social().instantiateViewController(withIdentifier: "SettingsNotificationsViewController") as! SettingsNotificationsViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
}
