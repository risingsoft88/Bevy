//
//  NewPwdViewController.swift
//  Bevy
//
//  Created by macOS on 6/18/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class NewPwdViewController: UIViewController {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var viewWrapperBlack: UIView!
    @IBOutlet weak var viewWrapperWhite: UIView!
    @IBOutlet weak var viewCurrentPwd: UIView!
    @IBOutlet weak var viewNewPwd: UIView!
    @IBOutlet weak var viewRepwd: UIView!
    @IBOutlet weak var editCurrentPwd: UITextField!
    @IBOutlet weak var editNewPwd: UITextField!
    @IBOutlet weak var editRepwd: UITextField!

    var hideCurrentPassword = true
    var hideNewPassword = true
    var hideRepassword = true

    override func viewDidLoad() {
        super.viewDidLoad()

        btnUpdate.layer.cornerRadius = 10
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        viewWrapperBlack.topRoundedView()
        viewWrapperWhite.topRoundedView()
        viewWrapperWhite.isHidden = true

        viewCurrentPwd.addBottomBorderWithColor(color: UIColor.black, width: 2)
        viewNewPwd.addBottomBorderWithColor(color: UIColor.black, width: 2)
        viewRepwd.addBottomBorderWithColor(color: UIColor.black, width: 2)
    }

    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func showCurrentPassword(_ sender: Any) {
        hideCurrentPassword = !hideCurrentPassword
        editCurrentPwd.isSecureTextEntry = hideCurrentPassword
    }

    @IBAction func showNewPassword(_ sender: Any) {
        hideNewPassword = !hideNewPassword
        editNewPwd.isSecureTextEntry = hideNewPassword
    }

    @IBAction func showRepassword(_ sender: Any) {
        hideRepassword = !hideRepassword
        editRepwd.isSecureTextEntry = hideRepassword
    }

    private func showErrorAndHideProgress(text: String) {
        SVProgressHUD.dismiss()
        self.showError(text: text)
    }

    @IBAction func updateClicked(_ sender: Any) {
        guard let currentPwd = editCurrentPwd.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let newPwd = editNewPwd.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let rePwd = editRepwd.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }

        if currentPwd != AppManager.shared.currentUser?.password {
            showAlert("Don't match current password!")
            return
        }

        if !newPwd.isValidPassword(){
            showAlert("Please enter a new password with 6 or more characters!")
            return
        }

        if !rePwd.isValidPassword() {
            showAlert("Please enter a re-password with 6 or more characters!")
            return
        }

        if newPwd != rePwd {
            showAlert("New passwords are not equivalant each other!")
            return
        }

        SVProgressHUD.show()
        Auth.auth().currentUser?.updatePassword(to: newPwd) { (error) in
            if let error = error {
                self.showErrorAndHideProgress(text: error.localizedDescription)
                return
            }

            SVProgressHUD.dismiss()
            if let currentUserRef = AppManager.shared.currentUserRef {
                currentUserRef.updateData(["password": newPwd]);
            }
            if let currentUser = AppManager.shared.currentUser {
                currentUser.password = newPwd;
                AppManager.shared.saveCurrentUser(user: currentUser)
            }
            let alertController = UIAlertController(title: "Passwords updated successfully!", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                let defaults = UserDefaults.standard
                defaults.set(newPwd, forKey: "userpwd")
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        }
    }

    @IBAction func signupClicked(_ sender: Any) {
        let signupVC = R.storyboard.auth().instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        signupVC.modalPresentationStyle = .fullScreen
        self.present(signupVC, animated: true, completion: nil)
    }
}

