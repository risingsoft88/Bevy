//
//  BaseMenuViewController.swift
//  Bevy
//
//  Created by macOS on 6/22/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import SideMenu

class BaseMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSideMenu()
        updateMenus()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sideMenuNavigationController = segue.destination as? SideMenuNavigationController else { return }
        sideMenuNavigationController.settings = makeSettings()
    }

    private func setupSideMenu() {
        SideMenuManager.default.leftMenuNavigationController = R.storyboard.menu().instantiateViewController(withIdentifier: "LeftMenuViewController") as? SideMenuNavigationController
        SideMenuManager.default.rightMenuNavigationController = R.storyboard.menu().instantiateViewController(withIdentifier: "RightMenuViewController") as? SideMenuNavigationController
    }

    private func selectedPresentationStyle() -> SideMenuPresentationStyle {
        return .viewSlideOut
    }

    private func makeSettings() -> SideMenuSettings {
        let presentationStyle = selectedPresentationStyle()
        presentationStyle.presentingScaleFactor = 0.8
//        guard let img = UIImage(named: "Splash.png") else { return settings}
        presentationStyle.backgroundColor = UIColor.white

        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        settings.menuWidth = min(view.frame.width, view.frame.height) * 0.6
        settings.statusBarEndAlpha = 0

        return settings
    }

    private func updateMenus() {
        let settings = makeSettings()
        SideMenuManager.default.leftMenuNavigationController?.settings = settings
        SideMenuManager.default.rightMenuNavigationController?.settings = settings
    }
}

