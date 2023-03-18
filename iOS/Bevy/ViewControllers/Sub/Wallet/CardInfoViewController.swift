//
//  CardInfoViewController.swift
//  Bevy
//
//  Created by macOS on 8/12/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import Stripe
import CreditCardForm

class CardInfoViewController: BaseSubViewController {

    @IBOutlet weak var lblTransactions: UILabel!
    @IBOutlet weak var lblSettings: UILabel!
    @IBOutlet weak var lblReport: UILabel!
    @IBOutlet weak var imgContent: UIImageView!
    @IBOutlet weak var creditCardView: CreditCardFormView!

    var selectedTabIndex = 0
    var cardInfo: Card? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(transcationsTapped(tapGestureRecognizer:)))
        lblTransactions.isUserInteractionEnabled = true
        lblTransactions.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(settingsTapped(tapGestureRecognizer:)))
        lblSettings.isUserInteractionEnabled = true
        lblSettings.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(reportTapped(tapGestureRecognizer:)))
        lblReport.isUserInteractionEnabled = true
        lblReport.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(contentTapped(tapGestureRecognizer:)))
        imgContent.isUserInteractionEnabled = true
        imgContent.addGestureRecognizer(tapGestureRecognizer)

        selectedTabIndex = 0
        selectTabs()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if (cardInfo != nil) {
            // load saved card params
            creditCardView.paymentCardTextFieldDidChange(cardNumber: cardInfo?.cardNumber, expirationYear: cardInfo?.expirationYear, expirationMonth: cardInfo?.expirationMonth, cvc: cardInfo!.cvc)
            creditCardView.cardHolderString = cardInfo!.cardHolder!
        }
    }

    private func selectTabs() {
        lblTransactions.layer.sublayers?.removeAll()
        lblSettings.layer.sublayers?.removeAll()
        lblReport.layer.sublayers?.removeAll()

        if (selectedTabIndex == 0) {
            addBottomBorder(label: lblTransactions)
            imgContent.image = R.image.img_card_transaction()
        } else if (selectedTabIndex == 1) {
            addBottomBorder(label: lblSettings)
            imgContent.image = R.image.img_card_settings()
        } else if (selectedTabIndex == 2) {
            addBottomBorder(label: lblReport)
            imgContent.image = R.image.img_card_report()
        }
    }

    func addBottomBorder(label: UILabel) {
        label.layoutIfNeeded()
        let border = CALayer()
        border.backgroundColor = UIColor(rgb: 0xD73A31).cgColor
        border.frame = CGRect(x: (label.frame.size.width-20)/2, y: label.frame.size.height+5, width: 20, height: 4)
        label.layer.addSublayer(border)
    }

    @objc func transcationsTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        selectedTabIndex = 0
        selectTabs()
    }

    @objc func settingsTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        selectedTabIndex = 1
        selectTabs()
    }

    @objc func reportTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        selectedTabIndex = 2
        selectTabs()
    }

    @objc func contentTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if (selectedTabIndex == 0) {
            let vc = R.storyboard.wallet().instantiateViewController(withIdentifier: "WalletTransactionViewController") as! WalletTransactionViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }

}
