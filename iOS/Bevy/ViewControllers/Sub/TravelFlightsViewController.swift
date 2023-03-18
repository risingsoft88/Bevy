//
//  TravelFlightsViewController.swift
//  Bevy
//
//  Created by macOS on 6/29/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class TravelFlightsViewController: BaseSubViewController {

    @IBOutlet weak var viewOneWay: UIView!
    @IBOutlet weak var lblOneWay: UILabel!
    @IBOutlet weak var viewRoundtrip: UIView!
    @IBOutlet weak var lblRoundtrip: UILabel!
    @IBOutlet weak var viewMulticity: UIView!
    @IBOutlet weak var lblMulticity: UILabel!

    @IBOutlet weak var btnFindFlights: UIButton!

    var nSelectedTab: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        btnFindFlights.layer.cornerRadius = 5

        let tapOneWay = UITapGestureRecognizer(target: self, action: #selector(onewayClicked))
        viewOneWay.isUserInteractionEnabled = true
        viewOneWay.addGestureRecognizer(tapOneWay)
        let tapRoundtrip = UITapGestureRecognizer(target: self, action: #selector(roundtripClicked))
        viewRoundtrip.isUserInteractionEnabled = true
        viewRoundtrip.addGestureRecognizer(tapRoundtrip)
        let tapMulticity = UITapGestureRecognizer(target: self, action: #selector(multicityClicked))
        viewMulticity.isUserInteractionEnabled = true
        viewMulticity.addGestureRecognizer(tapMulticity)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        nSelectedTab = 0
        showTab(index: nSelectedTab)
    }

    @objc func onewayClicked() {
        nSelectedTab = 0
        showTab(index: nSelectedTab)
    }

    @objc func roundtripClicked() {
        nSelectedTab = 1
        showTab(index: nSelectedTab)
    }

    @objc func multicityClicked() {
        nSelectedTab = 2
        showTab(index: nSelectedTab)
    }

    func showTab(index: Int) {
        if (index == 0) {
            viewOneWay.backgroundColor = UIColor.white
            viewOneWay.rightRoundedView()
            viewRoundtrip.backgroundColor = UIColor.clear
            viewMulticity.backgroundColor = UIColor.clear
            lblOneWay.textColor = UIColor.black
            lblRoundtrip.textColor = UIColor.white
            lblMulticity.textColor = UIColor.white
        } else if (index == 1) {
            viewOneWay.backgroundColor = UIColor.clear
            viewRoundtrip.backgroundColor = UIColor.white
            viewRoundtrip.layer.cornerRadius = 10
            viewMulticity.backgroundColor = UIColor.clear
            lblOneWay.textColor = UIColor.white
            lblRoundtrip.textColor = UIColor.black
            lblMulticity.textColor = UIColor.white
        } else if (index == 2) {
            viewOneWay.backgroundColor = UIColor.clear
            viewRoundtrip.backgroundColor = UIColor.clear
            viewMulticity.backgroundColor = UIColor.white
            viewMulticity.leftRoundedView()
            lblOneWay.textColor = UIColor.white
            lblRoundtrip.textColor = UIColor.white
            lblMulticity.textColor = UIColor.black
        }
    }

    @IBAction func searchClicked(_ sender: Any) {
        let viewController = R.storyboard.sub().instantiateViewController(withIdentifier: "FlightsSearchViewController") as! FlightsSearchViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
}
