//
//  HotelSearchViewController.swift
//  Bevy
//
//  Created by macOS on 7/9/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class HotelSearchViewController: BaseSubViewController {

    @IBOutlet weak var imgContent: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(contentTapped(tapGestureRecognizer:)))
        imgContent.isUserInteractionEnabled = true
        imgContent.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func contentTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let vc = R.storyboard.sub().instantiateViewController(withIdentifier: "HotelDetailViewController") as! HotelDetailViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

}
