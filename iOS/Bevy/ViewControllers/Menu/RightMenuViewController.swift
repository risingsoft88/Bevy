//
//  RightMenuViewController.swift
//  Bevy
//
//  Created by macOS on 6/27/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class RightMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableViewMenu: UITableView!
    @IBOutlet weak var imgAvatar: UIImageView!

    var menuTitles = [[String]]()
    var menuInactiveIcons = [UIImage?]()
    var menuActiveIcons = [UIImage?]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewMenu.dataSource = self
        tableViewMenu.delegate = self
        tableViewMenu.register(R.nib.rightMenuTableViewCell)

        Utils.loadAvatar(imgAvatar)
    }

    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let nCount = AppConstants.shared.rightMenuTitles[AppConstants.shared.nLeftMenuSelectedIndex].count
        let str = AppConstants.shared.leftMenuTitles[AppConstants.shared.nLeftMenuSelectedIndex]
        if (str == "Social") {
            return nCount - 1
        } else if (str == "Wallet") {
            return nCount - 2
        }
        return nCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RightMenuTableViewCell", for: indexPath) as! RightMenuTableViewCell
        let title = AppConstants.shared.rightMenuTitles[AppConstants.shared.nLeftMenuSelectedIndex][indexPath.row]
//        if (AppConstants.shared.nRightMenuSelectedIndex == indexPath.row) {
//            cell.lblTitle.textColor = UIColor.gray
//            cell.imgIcon.image = menuInactiveIcons[indexPath.row]
//        } else {
//            cell.lblTitle.textColor = UIColor.gray
//            cell.imgIcon.image = menuInactiveIcons[indexPath.row]
//        }
        cell.lblTitle.text = title
        cell.lblTitle.textColor = UIColor.gray
        cell.imgIcon.image = AppConstants.shared.rightMenuInactiveIcons[AppConstants.shared.nLeftMenuSelectedIndex][indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        AppConstants.shared.nRightMenuSelectedIndex = indexPath.row

        let strController = AppConstants.shared.rightMenuViewControllers[AppConstants.shared.nLeftMenuSelectedIndex][indexPath.row]
        var storyboard : UIStoryboard
        if (AppConstants.shared.nLeftMenuSelectedIndex == 0) {
            storyboard = R.storyboard.wallet()
        } else {
            storyboard = R.storyboard.sub()
        }
        if (strController == "MainViewController" || strController == "SupportViewController") {
            storyboard = R.storyboard.sub()
        }
        let viewController = storyboard.instantiateViewController(withIdentifier: strController)
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false, completion: nil)
    }
}

