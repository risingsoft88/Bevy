//
//  TopupViewController.swift
//  Bevy
//
//  Created by macOS on 11/6/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import CurrencyTextField
import Stripe
import CreditCardForm
import Alamofire
import SVProgressHUD
import SwiftyJSON

protocol TopupViewControllerDelegate : NSObjectProtocol{
    func chargeMoney()
}

class TopupViewController: BaseSubViewController, STPPaymentCardTextFieldDelegate, WalletAccountsViewControllerDelegate {

    weak var delegate : TopupViewControllerDelegate?

    let paymentTextField = STPPaymentCardTextField()

    @IBOutlet weak var viewCardInputWrapper: UIView!
    @IBOutlet weak var editAmount: CurrencyTextField!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var viewSuccess: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnSuccessBack: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        createTextField()

        btnConfirm.layer.cornerRadius = 10
        btnSuccessBack.layer.cornerRadius = 10

        viewCardInputWrapper.layer.cornerRadius = 5
        viewCardInputWrapper.layer.borderColor = UIColor(rgb: 0x484848).cgColor
        viewCardInputWrapper.layer.borderWidth = 1
        viewCardInputWrapper.layer.masksToBounds = true;

        viewContainer.layer.cornerRadius = 10
        viewContainer.layer.borderColor = UIColor.gray.cgColor
        viewContainer.layer.borderWidth = 1
        viewSuccess.isHidden = true
    }

    func createTextField() {
        paymentTextField.frame = CGRect(x: 0, y: 0, width: self.viewCardInputWrapper.frame.size.width, height: self.viewCardInputWrapper.frame.size.height)
        paymentTextField.delegate = self
        paymentTextField.textColor = UIColor.black
        paymentTextField.borderWidth = 0
        paymentTextField.postalCodeEntryEnabled = false
        viewCardInputWrapper.addSubview(paymentTextField)
    }

    @IBAction func clickedChooseCard(_ sender: Any) {
        let vc = R.storyboard.wallet().instantiateViewController(withIdentifier: "WalletAccountsViewController") as! WalletAccountsViewController
        vc.isChoose = true
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func clickedSuccessBack(_ sender: Any) {
        viewSuccess.isHidden = true
//        if let delegate = self.delegate {
//            delegate.chargeMoney()
//        }
//        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func clickedConfirm(_ sender: Any) {
        let cardParams = STPCardParams()
        cardParams.number = paymentTextField.cardNumber
        cardParams.expMonth = UInt(paymentTextField.expirationMonth)
        cardParams.expYear = UInt(paymentTextField.expirationYear)
        cardParams.cvc = paymentTextField.cvc

        if (!paymentTextField.isValid) {
            showAlert("Please enter a valid card info!")
            return
        }

        guard let amount = editAmount.text?.trimmingCharacters(in: .whitespacesAndNewlines).dropFirst(1).replacingOccurrences(of: ".", with: "", options: .literal, range: nil).replacingOccurrences(of: ",", with: "", options: .literal, range: nil) else { return }

        let intAmount = Int(amount) ?? 0

        if intAmount <= 0 {
//            showAlert("Please enter more than 50 cents!")
            showAlert("Please enter valid amount!")
            return
        }

        let alertController = UIAlertController(title: "Do you want to process?", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // cancel action
        }
        alertController.addAction(cancelAction)
        let ResendAction = UIAlertAction(title: "OK", style: .default) { (action) in
            SVProgressHUD.show()

            STPAPIClient.shared.createToken(withCard: cardParams) { token, error in
                guard let token = token else {
                    SVProgressHUD.dismiss()
                    self.showError(text: error!.localizedDescription)
                    return
                }
                let tokenID = token.tokenId
                // Send the token identifier to your server...
                // https://us-central1-bevy-b3121.cloudfunctions.net/chargeBevyBalance?userid=userid&amount=amount&token=token

                guard let userID = AppManager.shared.currentUser?.userID else {
                    SVProgressHUD.dismiss()
                    self.showError(text: "Unexpected Error!")
                    return
                }

                let scheme = "https"
                let host = "us-central1-bevy-b3121.cloudfunctions.net"
                let path = "/chargeBevyBalance"
                let queryItem0 = URLQueryItem(name: "userid", value: userID)
                let queryItem1 = URLQueryItem(name: "amount", value: String(intAmount))
                let queryItem2 = URLQueryItem(name: "token", value: String(tokenID))
                let queryItem3 = URLQueryItem(name: "createdAt", value: String(Date().timeIntervalSince1970))

                var urlComponents = URLComponents()
                urlComponents.scheme = scheme
                urlComponents.host = host
                urlComponents.path = path
                urlComponents.queryItems = [queryItem0, queryItem1, queryItem2, queryItem3]

                if let url = urlComponents.url {
                    let request = AF.request(url)
                    request.responseJSON { (response) in
                        if let json = response.data {
                            do {
                                let data = try JSON(data: json)
                                print(data)
                                let statusCode = data["statusCode"].intValue
                                let message = data["body"]["message"].stringValue
                                SVProgressHUD.dismiss()
                                if (statusCode == 200) {
                                    AppConstants.shared.isDirtyBalance = true
                                    self.viewSuccess.isHidden = false
                                    AppManager.shared.currentUser!.availableAmount! += intAmount
                                    self.dismiss(animated: true, completion: nil)
                                    self.delegate?.chargeMoney()
                                } else {
                                    self.showError(text: message)
                                }
                                return
                            } catch {
                                print("JSON Error")
                                SVProgressHUD.dismiss()
                                self.showError(text: "JSON Parsing failed!")
                                return
                            }
                        } else {
                            SVProgressHUD.dismiss()
                            self.showError(text: "Unexpected error!")
                        }
                    }
                } else {
                    SVProgressHUD.dismiss()
                    self.showError(text: "Charging failed!")
                    return
                }
            }
        }
        alertController.addAction(ResendAction)
        self.present(alertController, animated: true)
    }

    func selectCardWith(cardInfo: Card) {
        let cardParams = STPPaymentMethodCardParams()
        cardParams.number = cardInfo.cardNumber
        cardParams.expMonth = cardInfo.expirationMonth as NSNumber?
        cardParams.expYear = cardInfo.expirationYear as NSNumber?
        cardParams.cvc = cardInfo.cvc
        self.paymentTextField.cardParams = cardParams
    }
}
