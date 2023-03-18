//
//  ResetPwdViewController.swift
//  Bevy
//
//  Created by macOS on 6/18/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import FirebaseAuth

class ResetPwdViewController: UIViewController {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var viewWrapperBlack: UIView!
    @IBOutlet weak var viewWrapperWhite: UIView!
    @IBOutlet weak var viewInputWrapper: UIView!
    @IBOutlet weak var editEmail: UITextField!
    @IBOutlet weak var imgEmailCheck: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        btnReset.layer.cornerRadius = 10
        viewInputWrapper.layer.cornerRadius = 5
        viewInputWrapper.layer.borderColor = UIColor(rgb: 0x484848).cgColor
        viewInputWrapper.layer.borderWidth = 1
        viewInputWrapper.layer.masksToBounds = true

        imgEmailCheck.isHidden = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        viewWrapperBlack.topRoundedView()
        viewWrapperWhite.topRoundedView()
    }

    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func editEmailChanged(_ sender: Any) {
        guard let email = editEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }

        imgEmailCheck.isHidden = !email.isValidEmail()
    }

    @IBAction func resetClicked(_ sender: Any) {
        guard let email = editEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }

        if (email.isValidEmail()) {
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    self.showError(text: error.localizedDescription)
                    return
                }

                let alertController = UIAlertController(title: "We've sent reset email to you, please check email box!", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
            }
        } else {
            self.showAlert("Please enter a valid email!")
        }
    }

    @IBAction func signupClicked(_ sender: Any) {
        let signupVC = R.storyboard.auth().instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        signupVC.modalPresentationStyle = .fullScreen
        self.present(signupVC, animated: true, completion: nil)
    }
}

