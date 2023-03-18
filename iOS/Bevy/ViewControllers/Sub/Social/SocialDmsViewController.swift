//
//  SocialDmsViewController.swift
//  Bevy
//
//  Created by macOS on 8/4/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class SocialDmsViewController: BaseSubViewController {

    @IBOutlet weak var imgDMContent: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgDMContent.isUserInteractionEnabled = true
        imgDMContent.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let vc = R.storyboard.social().instantiateViewController(withIdentifier: "DMDirectViewController") as! DMDirectViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

}
