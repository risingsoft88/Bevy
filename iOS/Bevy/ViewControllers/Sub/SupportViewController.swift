//
//  SupportViewController.swift
//  Bevy
//
//  Created by macOS on 8/5/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import MessageUI

class SupportViewController: BaseSubViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var viewAlert: UIView!
    @IBOutlet weak var editMessage: UITextView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var editUsername: UITextField!
    @IBOutlet weak var editEmail: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewAlert.isHidden = true
        btnSend.layer.cornerRadius = 10
        btnBack.layer.cornerRadius = 10
        editMessage.layer.cornerRadius = 10
        editMessage.layer.borderWidth = 1
        editMessage.layer.borderColor = UIColor.white.cgColor
        editUsername.text = AppManager.shared.currentUser?.username
        editEmail.text = AppManager.shared.currentUser?.email
    }

    @IBAction func sendClicked(_ sender: Any) {
//        viewAlert.isHidden = false
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self

            // Configure the fields of the interface.
            composeVC.setToRecipients(["support@getbevy.app"])
            composeVC.setSubject("")
            composeVC.setMessageBody(editMessage.text, isHTML: false)

            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
    }

    @IBAction func msgBackClicked(_ sender: Any) {
//        viewAlert.isHidden = true
    }

    //MARK: MFMail Compose ViewController Delegate method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
