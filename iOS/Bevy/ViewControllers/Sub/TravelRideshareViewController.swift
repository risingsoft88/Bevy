//
//  TravelRideshareViewController.swift
//  Bevy
//
//  Created by macOS on 6/29/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class TravelRideshareViewController: BaseSubViewController {

    @IBOutlet weak var imgContent: UIImageView!
    @IBOutlet weak var viewBottom: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let contentTap = UITapGestureRecognizer(target: self, action: #selector(contentClicked))
        imgContent.isUserInteractionEnabled = true
        imgContent.addGestureRecognizer(contentTap)

        viewBottom.topRoundedView()
    }

    @objc func contentClicked() {
        let viewController = R.storyboard.sub().instantiateViewController(withIdentifier: "RideshareMapViewController") as! RideshareMapViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }

}
