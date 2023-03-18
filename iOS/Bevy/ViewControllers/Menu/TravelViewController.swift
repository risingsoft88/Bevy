//
//  TravelViewController.swift
//  Bevy
//
//  Created by macOS on 6/27/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class TravelViewController: BaseMenuViewController {

    @IBOutlet weak var viewContent: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewContent.topRoundedView()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
