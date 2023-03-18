//
//  TravelHotelsViewController.swift
//  Bevy
//
//  Created by macOS on 7/9/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class TravelHotelsViewController: BaseSubViewController {

    @IBOutlet weak var btnContinue: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        btnContinue.layer.cornerRadius = 10
    }

    @IBAction func continueClicked(_ sender: Any) {
        let vc = R.storyboard.sub().instantiateViewController(withIdentifier: "HotelSearchViewController") as! HotelSearchViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

}
