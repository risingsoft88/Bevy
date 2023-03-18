//
//  DMDirectViewController.swift
//  Bevy
//
//  Created by macOS on 8/12/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class DMDirectViewController: BaseSubViewController {

    @IBOutlet weak var viewInputWrapper: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewInputWrapper.layer.cornerRadius = viewInputWrapper.frame.size.height / 2
    }

    @IBAction func videoCallClicked(_ sender: Any) {
        let vc = R.storyboard.social().instantiateViewController(withIdentifier: "VideoCallViewController") as! VideoCallViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func sendMessageClicked(_ sender: Any) {
    }
}
