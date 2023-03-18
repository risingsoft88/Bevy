//
//  AddCardViewController.swift
//  Bevy
//
//  Created by macOS on 8/6/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import Stripe
import CreditCardForm
import SVProgressHUD
import Firebase
import FirebaseFirestore

protocol AddCardViewControllerDelegate : NSObjectProtocol{
    func addCardWith(cardInfo: Card, cardRef: DocumentReference, isAdd: Bool, cardIndex: Int)
}

class AddCardViewController: BaseSubViewController, STPPaymentCardTextFieldDelegate {

    weak var delegate : AddCardViewControllerDelegate?

    @IBOutlet weak var btnAddCard: UIButton!
    @IBOutlet weak var viewCardInfo: UIView!
    @IBOutlet weak var viewCardHolder: UIView!
    @IBOutlet weak var creditCardView: CreditCardFormView!

    var isAdd = true
    var cardIndex = 0
    var cardInfo: Card? = nil
    var cardInfoRef: DocumentReference? = nil

    let paymentTextField = STPPaymentCardTextField()
    private var cardHolderNameTextField: TextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        createTextField()

        cardHolderNameTextField.text = AppManager.shared.currentUser!.firstname! + " " + AppManager.shared.currentUser!.lastname!
        creditCardView.cardHolderString = AppManager.shared.currentUser!.firstname! + " " + AppManager.shared.currentUser!.lastname!

        btnAddCard.layer.cornerRadius = 10
        btnAddCard.setTitle(isAdd ? "Add" : "Update", for: .normal)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if (cardInfo != nil) {
            // load saved card params
            creditCardView.paymentCardTextFieldDidChange(cardNumber: cardInfo?.cardNumber, expirationYear: cardInfo?.expirationYear, expirationMonth: cardInfo?.expirationMonth, cvc: cardInfo!.cvc)
            creditCardView.cardHolderString = cardInfo!.cardHolder!
            let cardParams = STPPaymentMethodCardParams()
            cardParams.number = cardInfo?.cardNumber
            cardParams.expMonth = cardInfo?.expirationMonth as NSNumber?
            cardParams.expYear = cardInfo?.expirationYear as NSNumber?
            cardParams.cvc = cardInfo?.cvc
            self.paymentTextField.cardParams = cardParams
            creditCardView.backLineColor = UIColor.blue
        }
    }

    func createTextField() {
        cardHolderNameTextField = TextField(frame: CGRect(x: 0, y: 0, width: self.viewCardHolder.frame.size.width, height: self.viewCardHolder.frame.size.height))
        cardHolderNameTextField.placeholder = "CARD HOLDER"
        cardHolderNameTextField.delegate = self
        cardHolderNameTextField.setBottomBorder()
        cardHolderNameTextField.addTarget(self, action: #selector(AddCardViewController.textFieldDidChange(_:)), for: .editingChanged)
        cardHolderNameTextField.textColor = UIColor.white
        viewCardHolder.addSubview(cardHolderNameTextField)

        paymentTextField.frame = CGRect(x: 0, y: 0, width: self.viewCardInfo.frame.size.width, height: self.viewCardInfo.frame.size.height)
        paymentTextField.delegate = self
//        paymentTextField.textContentType = .creditCardNumber
        paymentTextField.textColor = UIColor.white
        paymentTextField.borderWidth = 0
        paymentTextField.postalCodeEntryEnabled = false
        viewCardInfo.addSubview(paymentTextField)

        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: paymentTextField.frame.size.height - width, width: paymentTextField.frame.size.width, height: paymentTextField.frame.size.height)
        border.borderWidth = width
        paymentTextField.layer.addSublayer(border)
        paymentTextField.layer.masksToBounds = true
    }

    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: UInt(textField.expirationYear), expirationMonth: UInt(textField.expirationMonth), cvc: textField.cvc)
    }

    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidEndEditingExpiration(expirationYear: UInt(textField.expirationYear))
    }

    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidBeginEditingCVC()
    }

    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        creditCardView.paymentCardTextFieldDidEndEditingCVC()
    }

    private func showErrorAndHideProgress(text: String) {
        SVProgressHUD.dismiss()
        self.showError(text: text)
    }

    @IBAction func addCardClicked(_ sender: Any) {
        if (!paymentTextField.isValid) {
            showAlert("Please enter a valid card info!")
            return
        }
        guard let cardHolder = cardHolderNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        if cardHolder.isEmpty {
            showAlert("Please enter a card holder!")
            return
        }

        SVProgressHUD.show()
        let db = Firestore.firestore()
        db.collection("cards").whereField("userID", isEqualTo: AppManager.shared.currentUser!.userID!).getDocuments { (querySnapshot, error) in
            if let error = error {
                self.showErrorAndHideProgress(text: error.localizedDescription)
                return
            }

            guard let snapshot = querySnapshot else {
                self.showErrorAndHideProgress(text: "Unexpected error!")
                return
            }

            for document in snapshot.documents {
                let cardInfo = Card(JSON: document.data())
                if (cardInfo?.cardNumber == self.paymentTextField.cardNumber) {
                    self.showErrorAndHideProgress(text: "Card number already added.")
                    return
                }
            }

            var cardRef: DocumentReference
            cardRef = (self.isAdd ? db.collection("cards").document() : self.cardInfoRef)!

            let newCard = Card()
            newCard.userID = AppManager.shared.currentUser?.userID
            newCard.cardHolder = cardHolder
            newCard.cardNumber = self.paymentTextField.cardNumber
            newCard.expirationYear = UInt(self.paymentTextField.expirationYear)
            newCard.expirationMonth = UInt(self.paymentTextField.expirationMonth)
            newCard.cvc = self.paymentTextField.cvc
            newCard.createdAt = Date()

            cardRef.setData(newCard.toJSON()) { error in
                if let error = error {
                    self.showErrorAndHideProgress(text: error.localizedDescription)
                    return
                }

                SVProgressHUD.dismiss()
                if let delegate = self.delegate {
                    delegate.addCardWith(cardInfo: newCard, cardRef: cardRef, isAdd: self.isAdd, cardIndex: self.cardIndex)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

extension AddCardViewController: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        creditCardView.cardHolderString = textField.text!
    }
}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = UITextField.BorderStyle.none
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,   width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
