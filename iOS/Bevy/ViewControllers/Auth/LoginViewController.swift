//
//  LoginViewController.swift
//  Bevy
//
//  Created by macOS on 6/18/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var btnSignin: UIButton!
    @IBOutlet weak var btnSignup: UIButton!

    @IBOutlet weak var lblEmailTitle: UILabel!
    @IBOutlet weak var editEmail: UITextField!
    @IBOutlet weak var lblWelcomeTitle: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!

    @IBOutlet weak var editPassword: UITextField!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPassword: UIView!

    @IBOutlet weak var btnSigninAnother: UIButton!
    @IBOutlet weak var stackRemember: UIStackView!
    @IBOutlet weak var imgSwitch: UIImageView!

    var hidePassword = true
    var strRemember = ""
    var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()

        btnSignin.layer.cornerRadius = 10
        editPassword.isSecureTextEntry = hidePassword

        let tapRemember = UITapGestureRecognizer(target: self, action: #selector(rememberClicked))
        stackRemember.isUserInteractionEnabled = true
        stackRemember.addGestureRecognizer(tapRemember)

        let defaults = UserDefaults.standard
        strRemember = defaults.string(forKey: "remember") ?? ""
        setRemember()

        let useremail = defaults.string(forKey: "useremail") ?? ""
        if useremail != "" {
            lblEmailTitle.isHidden = true
            editEmail.isHidden = true
            lblWelcomeTitle.isHidden = false
            lblUsername.isHidden = false
            imgAvatar.isHidden = false
            AppManager.shared.loadUser()
            if let savedUser = AppManager.shared.currentUser {
                lblUsername.text = savedUser.username
                Utils.loadAvatar(imgAvatar)
            }
            btnSigninAnother.isHidden = false
            viewEmail.addBottomBorderWithColor(color: UIColor.clear, width: 2)
        } else {
            lblEmailTitle.isHidden = false
            editEmail.isHidden = false
            lblWelcomeTitle.isHidden = true
            lblUsername.isHidden = true
            imgAvatar.isHidden = true
            btnSigninAnother.isHidden = true
            viewEmail.addBottomBorderWithColor(color: UIColor.black, width: 2)
        }

        viewPassword.addBottomBorderWithColor(color: UIColor.black, width: 2)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let defaults = UserDefaults.standard
        let useremail = defaults.string(forKey: "useremail") ?? ""
        let userpwd = defaults.string(forKey: "userpwd") ?? ""
        if strRemember == "remember" && useremail != "" && userpwd != "" {
            self.signInWith(email: useremail, password: userpwd)
        }
    }

    @objc func rememberClicked() {
        if (isLoading) {
            return
        }
        strRemember = strRemember == "remember" ? "" : "remember"
        let defaults = UserDefaults.standard
        defaults.set(strRemember, forKey: "remember")
        setRemember()
    }

    private func setRemember() {
        if (strRemember == "remember") {
            imgSwitch.image = R.image.icon_switch_on_black()
        } else {
            imgSwitch.image = R.image.icon_switch_off_black()
        }
    }

    @IBAction func backClicked(_ sender: Any) {
        if (isLoading) {
            return
        }
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func showPasswordClicked(_ sender: Any) {
        if (isLoading) {
            return
        }
        hidePassword = !hidePassword
        editPassword.isSecureTextEntry = hidePassword
    }

    private func showErrorAndHideProgress(text: String) {
        isLoading = false
        strRemember = ""
        let defaults = UserDefaults.standard
        defaults.set("", forKey: "remember")
        setRemember()

        SVProgressHUD.dismiss()
        self.showError(text: text)
    }

    private func signInWith(email: String, password: String) {
        isLoading = true
        SVProgressHUD.show()

        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                self.showErrorAndHideProgress(text: error.localizedDescription)
                return
            }

            guard let _ = authResult else {
                self.showErrorAndHideProgress(text: "Could not log in. Please try again")
                return
            }

            let db = Firestore.firestore()
            db.collection("users").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
                if let error = error {
                    self.showErrorAndHideProgress(text: error.localizedDescription)
                    return
                }

                guard let snapshot = querySnapshot else {
                    self.showErrorAndHideProgress(text: "There was an error signing in.")
                    return
                }

                // User exists with the specified email, show error
                if let existingUserDocument = snapshot.documents.first {
                    let existingUser = User(JSON: existingUserDocument.data())
                    existingUser?.password = password
                    existingUserDocument.reference.updateData(["password": password]);
                    AppManager.shared.saveCurrentUserRef(userRef: existingUserDocument.reference)

                    guard let currentUser = Auth.auth().currentUser else {
                        self.showErrorAndHideProgress(text: "User login failed!")
                        return
                    }

                    currentUser.reload { (error) in
                        if let error = error {
                            self.showErrorAndHideProgress(text: error.localizedDescription)
                            return
                        }

                        if (existingUser?.cardID == nil || existingUser?.cardID == "") {
                            SVProgressHUD.dismiss()
                            self.isLoading = false

                            let alertController = UIAlertController(title: "Please complete your account!", message: nil, preferredStyle: .alert)
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                                // cancel action
                            }
                            alertController.addAction(cancelAction)
                            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                                let signupVC = R.storyboard.auth().instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
                                signupVC.modalPresentationStyle = .fullScreen
                                signupVC.newUserType = "email"
                                signupVC.newUserEmail = email
                                signupVC.newUserPwd = password
                                signupVC.newUsername = existingUser!.username!
                                signupVC.newFirstname = existingUser!.firstname!
                                signupVC.newLastname = existingUser!.lastname!
                                signupVC.newUserPhone = existingUser!.phone!
                                signupVC.newUserAddressline = existingUser!.addressline1!
                                signupVC.newUserCity = existingUser!.city!
                                signupVC.newUserState = existingUser!.state!
                                signupVC.newUserZip = existingUser!.zip!
                                self.present(signupVC, animated: true, completion: nil)
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true)
                            return
                        }

                        SVProgressHUD.dismiss()
                        self.isLoading = false
                        if (currentUser.isEmailVerified) {

                            if let token = Messaging.messaging().fcmToken {
                                existingUserDocument.reference.setData(["fcmToken": token], merge: true)
                            }

                            AppManager.shared.saveCurrentUser(user: existingUser!)

                            let defaults = UserDefaults.standard
                            defaults.set(email, forKey: "useremail")
                            defaults.set(password, forKey: "userpwd")

                            let skipOnboarding = defaults.string(forKey: "skipOnboarding") ?? ""
                            if (skipOnboarding == "skip") {
                                let vc = R.storyboard.auth().instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
                                vc.modalPresentationStyle = .fullScreen
                                self.present(vc, animated: true, completion: nil)
                            } else {
                                let vc = R.storyboard.auth().instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
                                vc.modalPresentationStyle = .fullScreen
                                self.present(vc, animated: true, completion: nil)
                            }
                        } else {
                            let alertController = UIAlertController(title: "Please verify your email address!", message: nil, preferredStyle: .alert)
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                                // cancel action
                            }
                            alertController.addAction(cancelAction)
                            let ResendAction = UIAlertAction(title: "Resend", style: .default) { (action) in
                                SVProgressHUD.show()
                                Auth.auth().currentUser?.sendEmailVerification { (error) in
                                    if let error = error {
                                        self.showErrorAndHideProgress(text: error.localizedDescription)
                                        return
                                    }

                                    SVProgressHUD.dismiss()
                                    self.showAlert("Please verify your email address!")
                                }
                            }
                            alertController.addAction(ResendAction)
                            self.present(alertController, animated: true)
                        }
                    }
                } else {
                    SVProgressHUD.dismiss()
                    self.isLoading = false

                    let alertController = UIAlertController(title: "Please complete your account!", message: nil, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                        // cancel action
                    }
                    alertController.addAction(cancelAction)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        let signupVC = R.storyboard.auth().instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
                        signupVC.modalPresentationStyle = .fullScreen
                        signupVC.newUserType = "email"
                        signupVC.newUserEmail = email
                        signupVC.newUserPwd = password
                        self.present(signupVC, animated: true, completion: nil)
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true)
                }
            }
        }
    }
    
    @IBAction func signinClicked(_ sender: Any) {
        if (isLoading) {
            return
        }
        guard var email = editEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let password = editPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }

        if email.isEmpty {
            let defaults = UserDefaults.standard
            email = defaults.string(forKey: "useremail") ?? ""
            if email.isEmpty {
                showAlert("Please enter a email address!")
                return
            }
        }

        if password.isEmpty {
            showAlert("Please enter a password!")
            return
        }

        self.signInWith(email: email, password: password)
    }

    @IBAction func forgotClicked(_ sender: Any) {
        if (isLoading) {
            return
        }
        let resetpwdVC = R.storyboard.auth().instantiateViewController(withIdentifier: "ResetPwdViewController") as! ResetPwdViewController
        resetpwdVC.modalPresentationStyle = .fullScreen
        self.present(resetpwdVC, animated: true, completion: nil)
    }

    @IBAction func signupClicked(_ sender: Any) {
        if (isLoading) {
            return
        }
        let signupVC = R.storyboard.auth().instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        signupVC.modalPresentationStyle = .fullScreen
        self.present(signupVC, animated: true, completion: nil)
    }

    @IBAction func signinAnotherClicked(_ sender: Any) {
        if (isLoading) {
            return
        }
        lblEmailTitle.isHidden = false
        editEmail.isHidden = false
        lblWelcomeTitle.isHidden = true
        lblUsername.isHidden = true
        imgAvatar.isHidden = true
        btnSigninAnother.isHidden = true
        viewEmail.addBottomBorderWithColor(color: UIColor.black, width: 2)
    }
}

