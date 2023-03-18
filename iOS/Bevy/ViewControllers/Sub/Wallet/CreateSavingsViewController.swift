//
//  CreateSavingsViewController.swift
//  Bevy
//
//  Created by macOS on 9/3/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import Stripe
import SVProgressHUD
import Firebase
import FirebaseFirestore
import CurrencyTextField
import Alamofire
import SwiftyJSON

protocol CreateSavingsViewControllerDelegate : NSObjectProtocol{
    func createSaving()
}

class CreateSavingsViewController: BaseSubViewController, UITextFieldDelegate {

    weak var delegate : CreateSavingsViewControllerDelegate?

    @IBOutlet weak var viewCardInput: UIView!
    @IBOutlet weak var viewDeposit: UIView!
    @IBOutlet weak var lblDeposit: UILabel!
    @IBOutlet weak var viewAmount: UIView!
    @IBOutlet weak var viewAuto: UIView!
    @IBOutlet weak var imgAuto: UIImageView!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var viewSuccess: UIView!
    @IBOutlet weak var btnSuccessBack: UIButton!
    @IBOutlet weak var inputAmount: CurrencyTextField!

    let paymentTextField = STPPaymentCardTextField()
    var bAutoSavings = false
    var nTime = 12

    override func viewDidLoad() {
        super.viewDidLoad()

        viewDeposit.addBottomBorderWithColor(color: UIColor.lightGray, width: 1)
        viewAmount.addBottomBorderWithColor(color: UIColor.lightGray, width: 1)
        viewAuto.addBottomBorderWithColor(color: UIColor.lightGray, width: 1)
        btnConfirm.layer.cornerRadius = 10
        btnSuccessBack.layer.cornerRadius = 10

        viewCardInput.layer.borderWidth = 1
        viewCardInput.layer.borderColor = UIColor.lightGray.cgColor
        viewCardInput.layer.cornerRadius = 10
        paymentTextField.frame = CGRect(x: 0, y: 0, width: self.viewCardInput.frame.size.width, height: self.viewCardInput.frame.size.height)
        paymentTextField.textColor = UIColor.white
        paymentTextField.borderWidth = 0
        paymentTextField.postalCodeEntryEnabled = false
        viewCardInput.addSubview(paymentTextField)

        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(autoTapped(tapGestureRecognizer:)))
        imgAuto.isUserInteractionEnabled = true
        imgAuto.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(depositTapped(tapGestureRecognizer:)))
        lblDeposit.isUserInteractionEnabled = true
        lblDeposit.addGestureRecognizer(tapGestureRecognizer)

        switchAutoSavings()
        selectDeposite(index: 12)
        viewSuccess.isHidden = true

        inputAmount.delegate = self
    }

    @IBAction func confirmClicked(_ sender: Any) {
        guard let amount = inputAmount.text?.trimmingCharacters(in: .whitespacesAndNewlines).dropFirst(1).replacingOccurrences(of: ".", with: "", options: .literal, range: nil).replacingOccurrences(of: ",", with: "", options: .literal, range: nil) else { return }

        let intAmount = Int(amount) ?? 0

        if intAmount < 500 {
            showAlert("Please enter more than $5")
            return
        }

//        var roundedAmount = intAmount % 100
//        if (roundedAmount > 0) {
//            roundedAmount = 100 - roundedAmount
//            intAmount = intAmount + roundedAmount
//        }

        let alertController = UIAlertController(title: "Do you want to process?", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // cancel action
        }
        alertController.addAction(cancelAction)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            SVProgressHUD.show()

            let db = Firestore.firestore()
            var userRef: DocumentReference

            userRef = db.collection("users").document(AppManager.shared.currentUser!.userID!)
            userRef.getDocument { (document, error) in
                if let error = error {
                    SVProgressHUD.dismiss()
                    self.showError(text: error.localizedDescription)
                    return
                }

                let currentUser = User(JSON: document!.data()!)
                AppManager.shared.saveCurrentUserRef(userRef: document!.reference)
                AppManager.shared.saveCurrentUser(user: currentUser!)

                if (currentUser!.availableAmount! < intAmount) {
                    SVProgressHUD.dismiss()
                    self.showError(text: "Please enter valid amount.")
                    return
                }

                // https://us-central1-bevy-b3121.cloudfunctions.net/createSaving?userid=userid&time=time&amount=amount&rounded=rounded&type=type&createdAt=createdAt

                let scheme = "https"
                let host = "us-central1-bevy-b3121.cloudfunctions.net"
                let path = "/createSaving"
                let queryItem0 = URLQueryItem(name: "userid", value: AppManager.shared.currentUser!.userID!)
                let queryItem1 = URLQueryItem(name: "time", value: String(self.nTime))
                let queryItem2 = URLQueryItem(name: "amount", value: String(intAmount))
                let queryItem3 = URLQueryItem(name: "rounded", value: "0")
                let queryItem4 = URLQueryItem(name: "type", value: "defaultsaving")
                let queryItem5 = URLQueryItem(name: "createdAt", value: String(Date().timeIntervalSince1970))

                var urlComponents = URLComponents()
                urlComponents.scheme = scheme
                urlComponents.host = host
                urlComponents.path = path
                urlComponents.queryItems = [queryItem0, queryItem1, queryItem2, queryItem3, queryItem4, queryItem5]

                if let url = urlComponents.url {
                    let request = AF.request(url)
                    request.responseJSON { (response) in
                        if let json = response.data {
                            do {
                                let data = try JSON(data: json)
                                print(data)
                                let statusCode = data["statusCode"].intValue
                                let message = data["body"]["message"].stringValue
                                let availableAmount = data["body"]["availableAmount"].intValue
                                let savedAmount = data["body"]["savedAmount"].intValue
                                SVProgressHUD.dismiss()
                                if (statusCode == 200) {
                                    AppManager.shared.currentUser!.availableAmount! = availableAmount
                                    AppManager.shared.currentUser!.savedAmount! = savedAmount
                                    AppConstants.shared.isDirtyBalance = true
                                    NotificationCenter.default.post(name: NSNotification.Name("com.dirty.balance"), object: nil)

                                    self.viewSuccess.isHidden = false
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
                    self.showError(text: "Creating saving failed!")
                    return
                }
            }
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }

    @IBAction func succssBackClicked(_ sender: Any) {
        viewSuccess.isHidden = true
        if let delegate = self.delegate {
            delegate.createSaving()
        }
        self.dismiss(animated: true, completion: nil)
    }

    func switchAutoSavings() {
        imgAuto.image = bAutoSavings ? R.image.icon_switch_on() : R.image.icon_switch_off()
    }

    @objc func autoTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        bAutoSavings = !bAutoSavings
        switchAutoSavings()
    }

    @objc func depositTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        var action = UIAlertAction(title: "12 Months", style: .default) {
            UIAlertAction in
            self.selectDeposite(index: 12)
        }
        alert.addAction(action)
        action = UIAlertAction(title: "9 Months", style: .default) {
            UIAlertAction in
            self.selectDeposite(index: 9)
        }
        alert.addAction(action)
        action = UIAlertAction(title: "6 Months", style: .default) {
            UIAlertAction in
            self.selectDeposite(index: 6)
        }
        alert.addAction(action)
        action = UIAlertAction(title: "3 Months", style: .default) {
            UIAlertAction in
            self.selectDeposite(index: 3)
        }
        alert.addAction(action)
        action = UIAlertAction(title: "None", style: .default) {
            UIAlertAction in
            self.selectDeposite(index: 0)
        }
        alert.addAction(action)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            UIAlertAction in
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    func selectDeposite(index: Int) {
        nTime = index
        switch index {
        case 12:
            lblDeposit.text = "12 Months"
            return
        case 9:
            lblDeposit.text = "9 Months"
            return
        case 6:
            lblDeposit.text = "6 Months"
            return
        case 3:
            lblDeposit.text = "3 Months"
            return
        case 0:
            lblDeposit.text = "None"
            return
        default:
            return
        }
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        inputAmount.text = "$0.00"
        return false
    }
}
