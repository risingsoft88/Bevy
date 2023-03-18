//
//  ResetCodeViewController.swift
//  Bevy
//
//  Created by macOS on 6/18/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class ResetCodeViewController: UIViewController {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var viewWrapperBlack: UIView!
    @IBOutlet weak var viewWrapperWhite: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        btnContinue.layer.cornerRadius = 10
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        viewWrapperBlack.topRoundedView()
        viewWrapperWhite.topRoundedView()
    }

    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func continueClicked(_ sender: Any) {
        let newpwdVC = R.storyboard.auth().instantiateViewController(withIdentifier: "NewPwdViewController") as! NewPwdViewController
        newpwdVC.modalPresentationStyle = .fullScreen
        self.present(newpwdVC, animated: true, completion: nil)
    }

    @IBAction func signupClicked(_ sender: Any) {
        let signupVC = R.storyboard.auth().instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        signupVC.modalPresentationStyle = .fullScreen
        self.present(signupVC, animated: true, completion: nil)
    }
}

