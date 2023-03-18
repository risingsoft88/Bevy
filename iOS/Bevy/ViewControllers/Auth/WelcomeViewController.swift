//
//  WelcomeViewController.swift
//  Bevy
//
//  Created by macOS on 6/18/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .left
        self.view.addGestureRecognizer(swipeRight)
    }

    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .left:
                AppConstants.shared.nLeftMenuSelectedIndex = 0
                let viewController = R.storyboard.menu().instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
                viewController.modalPresentationStyle = .fullScreen
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = CATransitionType.push
                transition.subtype = CATransitionSubtype.fromRight
                transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
                view.window!.layer.add(transition, forKey: kCATransition)
                self.present(viewController, animated: false, completion: nil)
            default:
                break
            }
        }
    }
}

