//
//  LeftMenuViewController.swift
//  Bevy
//
//  Created by macOS on 6/21/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class LeftMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableViewMenu: UITableView!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!

    var menuTitles = [String]()
    var menuInactiveIcons = [UIImage?]()
    var menuActiveIcons = [UIImage?]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewMenu.dataSource = self
        tableViewMenu.delegate = self
        tableViewMenu.register(R.nib.leftMenuTableViewCell)

        Utils.loadAvatar(imgAvatar)
        lblName.text = ""
        lblName.text = AppManager.shared.currentUser?.username
    }

    @IBAction func logoutClicked(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()

        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            showAlert("There was an error signing out.")
            return
        }

        AppManager.shared.logoutUser()
        let defaults = UserDefaults.standard
        defaults.set("", forKey: "useremail")
        defaults.set("", forKey: "userpwd")
        let loginwithVC = R.storyboard.auth().instantiateViewController(withIdentifier: "LoginWithViewController") as! LoginWithViewController
        presentViewController(viewController: loginwithVC)
    }

    func presentViewController (viewController: UIViewController) {
        viewController.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(viewController, animated: false, completion: nil)
    }

    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppConstants.shared.leftMenuTitles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuTableViewCell", for: indexPath) as! LeftMenuTableViewCell
        let title = AppConstants.shared.leftMenuTitles[indexPath.row]
        cell.lblTitle.text = title
        if (AppConstants.shared.nLeftMenuSelectedIndex == indexPath.row) {
            cell.lblTitle.textColor = UIColor.black
            cell.imgIcon.image = AppConstants.shared.leftMenuActiveIcons[indexPath.row]
        } else {
            cell.lblTitle.textColor = UIColor.gray
            cell.imgIcon.image = AppConstants.shared.leftMenuInactiveIcons[indexPath.row]
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        AppConstants.shared.nLeftMenuSelectedIndex = indexPath.row

        let viewController = R.storyboard.menu().instantiateViewController(withIdentifier: AppConstants.shared.leftMenuViewControllers[indexPath.row])
        presentViewController(viewController: viewController)
    }
}

