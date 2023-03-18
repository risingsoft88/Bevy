//
//  WalletSendMoneyViewController.swift
//  Bevy
//
//  Created by macOS on 8/5/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import CurrencyTextField
import SVProgressHUD
import Firebase
import FirebaseFirestore
import Alamofire
import SwiftyJSON

protocol WalletSendMoneyViewControllerDelegate : NSObjectProtocol{
    func gotoDashboard()
}

class WalletSendMoneyViewController: BaseSubViewController, UITextFieldDelegate {

    weak var delegate : WalletSendMoneyViewControllerDelegate?

    var isRequest = false
    var userInfo: User? = nil

    var fromRequestAccept = false
    var requestAmount = 0
    var requestID = ""

    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var viewAlert: UIView!
    @IBOutlet weak var editCurrency: CurrencyTextField!

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!

    @IBOutlet weak var imgAvatarConfirm: UIImageView!
    @IBOutlet weak var lblNameConfirm: UILabel!
    @IBOutlet weak var lblEmailConfirm: UILabel!
    @IBOutlet weak var lblAmount: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewAlert.isHidden = true
        btnSend.layer.cornerRadius = 10
        btnBack.layer.cornerRadius = 10

        editCurrency.delegate = self
        editCurrency.addTopBorderWithColor(color: UIColor.white, width: 2)
        editCurrency.addBottomBorderWithColor(color: UIColor.white, width: 2)

        if (userInfo != nil) {
            Utils.loadUserAvatar(self.imgAvatar, url: userInfo!.photoUrl ?? "")
            lblName.text = userInfo?.username
//            lblEmail.text = userInfo?.email
            Utils.loadUserAvatar(self.imgAvatarConfirm, url: userInfo!.photoUrl ?? "")
            lblNameConfirm.text = userInfo?.username
//            lblEmailConfirm.text = userInfo?.email
        }

        if (fromRequestAccept) {
            let available: Double = Double(requestAmount) / Double(100.0)
            editCurrency.text = String(format: "$%.2f", available)
            editCurrency.isUserInteractionEnabled = false
        }
    }

    @IBAction func sendClicked(_ sender: Any) {
        guard let amount = editCurrency.text?.trimmingCharacters(in: .whitespacesAndNewlines).dropFirst(1) else { return }

        let intAmount = Int((amount as NSString).floatValue * 100)
        let available: Double = Double(intAmount) / Double(100.0)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        let formatted = formatter.string(from: NSNumber(value: available))

        if intAmount < 50 {
            showAlert("Please enter more than 50 cents.")
            return
        }

        let alertController = UIAlertController(title: "Do you want to process?", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // cancel action
        }
        alertController.addAction(cancelAction)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if (self.isRequest) {
                SVProgressHUD.show()
                let db = Firestore.firestore()
                var docRef: DocumentReference
                docRef = db.collection("paymentrequests").document()

                let newRequest = PaymentRequest()
                newRequest.senderID = AppManager.shared.currentUser?.userID
                newRequest.senderUsername = AppManager.shared.currentUser?.username
                newRequest.senderEmail = AppManager.shared.currentUser?.email
                newRequest.senderPhotoUrl = AppManager.shared.currentUser?.photoUrl
                newRequest.receiverID = self.userInfo!.userID
                newRequest.receiverUsername = self.userInfo!.username
                newRequest.receiverEmail = self.userInfo!.email
                newRequest.receiverPhotoUrl = self.userInfo!.photoUrl
                newRequest.amount = intAmount
                newRequest.type = "request"
                newRequest.createdAt = Date()

                docRef.setData(newRequest.toJSON()) { error in
                    if let error = error {
                        SVProgressHUD.dismiss()
                        self.showError(text: error.localizedDescription)
                        return
                    }

                    SVProgressHUD.dismiss()
                    self.lblAmount.text = String(format: "Request Sent")
                    self.viewAlert.isHidden = false
                    NotificationCenter.default.post(name: NSNotification.Name("com.dirty.balance"), object: nil)
                    AppConstants.shared.isDirtyBalance = true
                    let sender = PushNotificationSender()
                    sender.sendPushNotification(to: self.userInfo!.fcmToken!, title: "Request received!", body: "You received $" + formatted! + " request from " + newRequest.senderUsername!)
                }
            } else {
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

                    if (intAmount > currentUser!.availableAmount!) {
                        SVProgressHUD.dismiss()
                        self.showAlert("Your balance is not available.")
                        return
                    }

                    // https://us-central1-bevy-b3121.cloudfunctions.net/createSent?senderID=senderID&receiverID=receiverID&amount=amount&type=type&createdAt=createdAt

                    let scheme = "https"
                    let host = "us-central1-bevy-b3121.cloudfunctions.net"
                    let path = "/createSent"
                    let queryItem0 = URLQueryItem(name: "senderID", value: AppManager.shared.currentUser?.userID)
                    let queryItem1 = URLQueryItem(name: "receiverID", value: self.userInfo!.userID)
                    let queryItem2 = URLQueryItem(name: "amount", value: String(intAmount))
                    let queryItem3 = URLQueryItem(name: "type", value: self.fromRequestAccept ? "sentforrequest" : "sent")
                    let queryItem4 = URLQueryItem(name: "createdAt", value: String(Date().timeIntervalSince1970))

                    var urlComponents = URLComponents()
                    urlComponents.scheme = scheme
                    urlComponents.host = host
                    urlComponents.path = path
                    urlComponents.queryItems = [queryItem0, queryItem1, queryItem2, queryItem3, queryItem4]

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

                                    SVProgressHUD.dismiss()

                                    if (statusCode == 200) {
                                        if (self.fromRequestAccept) {
                                            db.collection("paymentrequests").document(self.requestID).delete()
                                        }

                                        AppManager.shared.currentUser!.availableAmount! = availableAmount
                                        self.lblAmount.text = String(format: "Cash Sent")
                                        self.viewAlert.isHidden = false
                                        NotificationCenter.default.post(name: NSNotification.Name("com.dirty.balance"), object: nil)
                                        AppConstants.shared.isDirtyBalance = true
                                        let sender = PushNotificationSender()
                                        sender.sendPushNotification(to: self.userInfo!.fcmToken!, title: "Money received!", body: "You received $" + formatted! + " from " + currentUser!.username!)
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
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }

//    func getBevyBalance(amount: Float) {
//        guard let userID = AppManager.shared.currentUser?.userID else {
//            return
//        }
//
//        let scheme = "https"
//        let host = "us-central1-bevy-b3121.cloudfunctions.net"
//        let path = "/getBevyBalance"
//        let queryItem0 = URLQueryItem(name: "userid", value: userID)
//
//        var urlComponents = URLComponents()
//        urlComponents.scheme = scheme
//        urlComponents.host = host
//        urlComponents.path = path
//        urlComponents.queryItems = [queryItem0]
//
//        if let url = urlComponents.url {
//            let request = AF.request(url)
//            request.responseJSON { (response) in
//                if let json = response.data {
//                    do{
//                        let data = try JSON(data: json)
//                        let statusCode = data["statusCode"].intValue
//                        let message = data["body"]["message"].stringValue
//                        AppManager.shared.currentUser.availableAmount = data["body"]["available"].intValue
//                        if let arrayPayment = data["body"]["payments"].arrayObject {
//                            AppConstants.shared.payments.removeAll()
//                            for index in 0..<arrayPayment.count {
//                                let payment = Payment(JSON: arrayPayment[index] as! [String : Any])
//                                AppConstants.shared.payments.append(payment!)
//                            }
//                        }
//                        SVProgressHUD.dismiss()
//                        if (statusCode == 200) {
//                            self.lblAmount.text = String(format: "$%.2f Sent", amount)
//                            self.viewAlert.isHidden = false
//                        } else {
//                            self.showError(text: message)
//                        }
//                        return
//                    } catch {
//                        SVProgressHUD.dismiss()
//                        self.showError(text: "JSON Parsing failed!")
//                        return
//                    }
//                } else {
//                    SVProgressHUD.dismiss()
//                    self.showError(text: "Unexpected error!")
//                }
//            }
//        } else {
//            SVProgressHUD.dismiss()
//            self.showError(text: "Unexpected error!")
//        }
//    }

    @IBAction func dismissClicked(_ sender: Any) {
        viewAlert.isHidden = true
        self.dismiss(animated: true, completion: nil)
        if (!self.fromRequestAccept) {
            self.delegate?.gotoDashboard()
        }
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        editCurrency.text = "$0.00"
        return false
    }
}
