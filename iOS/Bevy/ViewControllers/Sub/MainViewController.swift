//
//  MainViewController.swift
//  Bevy
//
//  Created by macOS on 6/19/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import SideMenu

class MainViewController: BaseSubViewController {

    @IBOutlet weak var lblTitle: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.text = AppConstants.shared.leftMenuTitles[AppConstants.shared.nLeftMenuSelectedIndex] + " - " + AppConstants.shared.rightMenuTitles[AppConstants.shared.nLeftMenuSelectedIndex][AppConstants.shared.nRightMenuSelectedIndex] + " View Controller"
    }

}
