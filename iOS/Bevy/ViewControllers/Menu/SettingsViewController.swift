//
//  SettingsViewController.swift
//  Bevy
//
//  Created by macOS on 6/20/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class SettingsViewController: BaseMenuViewController {
    @IBOutlet weak var viewEditProfile: UIView!
    @IBOutlet weak var viewChangePassword: UIView!
    @IBOutlet weak var viewFeedback: UIView!
    @IBOutlet weak var viewLanguage: UIView!
    @IBOutlet weak var viewCountry: UIView!
    @IBOutlet weak var switchBooking: UIImageView!
    @IBOutlet weak var switchDeal: UIImageView!
    @IBOutlet weak var switchNoti: UIImageView!
    @IBOutlet weak var viewTerms: UIView!
    @IBOutlet weak var viewCopyright: UIView!
    @IBOutlet weak var viewPrivacy: UIView!

    var bBooking = true
    var bDeal = true
    var bNoti = false

    override func viewDidLoad() {
        super.viewDidLoad()

        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editProfileTapped(tapGestureRecognizer:)))
        viewEditProfile.isUserInteractionEnabled = true
        viewEditProfile.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changePasswordTapped(tapGestureRecognizer:)))
        viewChangePassword.isUserInteractionEnabled = true
        viewChangePassword.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(switchBookingTapped(tapGestureRecognizer:)))
        switchBooking.isUserInteractionEnabled = true
        switchBooking.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(switchDealTapped(tapGestureRecognizer:)))
        switchDeal.isUserInteractionEnabled = true
        switchDeal.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(switchNotiTapped(tapGestureRecognizer:)))
        switchNoti.isUserInteractionEnabled = true
        switchNoti.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(termsTapped(tapGestureRecognizer:)))
        viewTerms.isUserInteractionEnabled = true
        viewTerms.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(copyrightTapped(tapGestureRecognizer:)))
        viewCopyright.isUserInteractionEnabled = true
        viewCopyright.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(privacyTapped(tapGestureRecognizer:)))
        viewPrivacy.isUserInteractionEnabled = true
        viewPrivacy.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func editProfileTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let vc = R.storyboard.sub().instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    @objc func changePasswordTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if (AppManager.shared.currentUser?.userType == "facebook" || AppManager.shared.currentUser?.userType == "twitter" || AppManager.shared.currentUser?.userType == "google" || AppManager.shared.currentUser?.userType == "apple") {
            self.showAlert("You logged in with your social account, you can not change your password.")
            return
        }
        let newpwdVC = R.storyboard.auth().instantiateViewController(withIdentifier: "NewPwdViewController") as! NewPwdViewController
        newpwdVC.modalPresentationStyle = .fullScreen
        self.present(newpwdVC, animated: true, completion: nil)
    }

    @objc func switchBookingTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        bBooking = !bBooking
        switchBooking.image = bBooking ? R.image.icon_switch_on() : R.image.icon_switch_off()
    }

    @objc func switchDealTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        bDeal = !bDeal
        switchDeal.image = bDeal ? R.image.icon_switch_on() : R.image.icon_switch_off()
    }

    @objc func switchNotiTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        bNoti = !bNoti
        switchNoti.image = bNoti ? R.image.icon_switch_on() : R.image.icon_switch_off()
    }

    @objc func termsTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let vc = R.storyboard.sub().instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
        vc.modalPresentationStyle = .fullScreen
        vc.type = 0 // 0: "Terms &\nConditions", 1: "Copyright\nPolicy", 2: "Privacy\nPolicy"
        self.present(vc, animated: true, completion: nil)
    }

    @objc func copyrightTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let vc = R.storyboard.sub().instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
        vc.modalPresentationStyle = .fullScreen
        vc.type = 1 // 0: "Terms &\nConditions", 1: "Copyright\nPolicy", 2: "Privacy\nPolicy"
        self.present(vc, animated: true, completion: nil)
    }

    @objc func privacyTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let vc = R.storyboard.sub().instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
        vc.modalPresentationStyle = .fullScreen
        vc.type = 2 // 0: "Terms &\nConditions", 1: "Copyright\nPolicy", 2: "Privacy\nPolicy"
        self.present(vc, animated: true, completion: nil)
    }
}

