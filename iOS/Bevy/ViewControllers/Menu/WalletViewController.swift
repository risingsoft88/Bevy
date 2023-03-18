//
//  WalletViewController.swift
//  Bevy
//
//  Created by macOS on 6/26/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON
import FirebaseFirestore

class WalletViewController: BaseMenuViewController, TopupViewControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var lblAvailable: UILabel!
    @IBOutlet weak var lblPending: UILabel!
    @IBOutlet weak var viewSend: UIView!
    @IBOutlet weak var viewRequest: UIView!
    @IBOutlet weak var viewTopup: UIView!
    @IBOutlet weak var lblTransactions: UILabel!
    @IBOutlet weak var lblDeposits: UILabel!
    @IBOutlet weak var lblExpenses: UILabel!
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var viewRequestInfo: UIView!
    @IBOutlet weak var viewRequestInfoContent: UIView!
    @IBOutlet weak var lblRequestAmount: UILabel!
    @IBOutlet weak var lblRequestSender: UILabel!

    @IBOutlet weak var tblTransactions: UITableView!

    var paymentsForTableView : [Payment] = []
    var selectedTabIndex = 0
    var fromOther = false

    var selectedPaymentItem : Payment? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sendTapped(tapGestureRecognizer:)))
        viewSend.isUserInteractionEnabled = true
        viewSend.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(requestTapped(tapGestureRecognizer:)))
        viewRequest.isUserInteractionEnabled = true
        viewRequest.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(topupTapped(tapGestureRecognizer:)))
        viewTopup.isUserInteractionEnabled = true
        viewTopup.addGestureRecognizer(tapGestureRecognizer)

        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(transcationsTapped(tapGestureRecognizer:)))
        lblTransactions.isUserInteractionEnabled = true
        lblTransactions.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(depositsTapped(tapGestureRecognizer:)))
        lblDeposits.isUserInteractionEnabled = true
        lblDeposits.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(expensesTapped(tapGestureRecognizer:)))
        lblExpenses.isUserInteractionEnabled = true
        lblExpenses.addGestureRecognizer(tapGestureRecognizer)

        tblTransactions.dataSource = self
        tblTransactions.delegate = self
        tblTransactions.register(R.nib.transactionTableViewCell)

        selectedTabIndex = 0
        selectTabs()

        viewRequestInfo.isHidden = true
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissRequestInfoTapped(tapGestureRecognizer:)))
        viewRequestInfo.isUserInteractionEnabled = true
        viewRequestInfo.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(requestContentTapped(tapGestureRecognizer:)))
        viewRequestInfoContent.isUserInteractionEnabled = true
        viewRequestInfoContent.addGestureRecognizer(tapGestureRecognizer)

        NotificationCenter.default.addObserver(self, selector: #selector(dirtyBalance), name: NSNotification.Name("com.dirty.balance"), object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        viewInfo.topRoundedView()
        viewRequestInfoContent.topRoundedView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if (self.isBeingPresented || self.isMovingToParent || AppConstants.shared.isDirtyBalance) {
            getBevyBalance()
        }
    }

    @objc func dirtyBalance() {
        fromOther = true
        getBevyBalance()
    }

    func getBevyBalance() {
        AppConstants.shared.isDirtyBalance = false
        guard let userID = AppManager.shared.currentUser?.userID else {
            return
        }

        let scheme = "https"
        let host = "us-central1-bevy-b3121.cloudfunctions.net"
        let path = "/getBevyBalance"
        let queryItem0 = URLQueryItem(name: "userid", value: userID)

        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [queryItem0]

        if let url = urlComponents.url {

            if (!fromOther) {
                SVProgressHUD.show()
            }

            let request = AF.request(url)
            request.responseJSON { (response) in
                if let json = response.data {
                    do{
                        let data = try JSON(data: json)
                        print(data)
                        let statusCode = data["statusCode"].intValue
                        let message = data["body"]["message"].stringValue
                        AppManager.shared.currentUser!.availableAmount = data["body"]["available"].intValue
                        let available: Double = Double(data["body"]["available"].intValue) / Double(100.0)
                        if let arrayPayment = data["body"]["payments"].arrayObject {
                            AppConstants.shared.payments.removeAll()
                            for index in 0..<arrayPayment.count {
                                let payment = Payment(JSON: arrayPayment[index] as! [String : Any])
                                AppConstants.shared.payments.append(payment!)
                            }
                        }
                        if (!self.fromOther) {
                            SVProgressHUD.dismiss()
                        } else {
                            self.fromOther = false
                        }
                        if (statusCode == 200) {
                            let formatter = NumberFormatter()
                            formatter.numberStyle = .decimal
                            formatter.groupingSeparator = ","
                            formatter.maximumFractionDigits = 2
                            formatter.minimumFractionDigits = 2
                            let formatted = formatter.string(from: NSNumber(value: available))
                            self.lblAvailable.text = formatted //String(format: "%.2f", available)
//                            self.lblPending.text = String(pending)
                            self.reloadTableView()
                        } else {
                            self.showError(text: message)
                        }
                        return
                    } catch {
                        print("JSON Error")
                        if (!self.fromOther) {
                            SVProgressHUD.dismiss()
                        } else {
                            self.fromOther = false
                        }
                        self.showError(text: "JSON Parsing failed!")
                        return
                    }
                } else {
                    if (!self.fromOther) {
                        SVProgressHUD.dismiss()
                    } else {
                        self.fromOther = false
                    }
                    self.showError(text: "Unexpected error!")
                }
            }
        }
    }

    @objc func sendTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let vc = R.storyboard.wallet().instantiateViewController(withIdentifier: "UsersViewController") as! UsersViewController
        vc.isRequest = false
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    @objc func requestTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let vc = R.storyboard.wallet().instantiateViewController(withIdentifier: "UsersViewController") as! UsersViewController
        vc.isRequest = true
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
//        let scheme = "https"
//        let host = "us-central1-bevy-b3121.cloudfunctions.net"
//        let path = "/tempFunc"
//        let queryItem0 = URLQueryItem(name: "username", value: "mb")
//        let queryItem1 = URLQueryItem(name: "email", value: "mikebarker.it@outlook.com")
//        let queryItem2 = URLQueryItem(name: "phone_number", value: "18008675309")
//        let queryItem3 = URLQueryItem(name: "line1", value: "1234 Main Street")
//        let queryItem4 = URLQueryItem(name: "city", value: "San Francisco")
//        let queryItem5 = URLQueryItem(name: "state", value: "CA")
//        let queryItem6 = URLQueryItem(name: "postal_code", value: "94111")
//
//        var urlComponents = URLComponents()
//        urlComponents.scheme = scheme
//        urlComponents.host = host
//        urlComponents.path = path
//        urlComponents.queryItems = [queryItem0, queryItem1, queryItem2, queryItem3, queryItem4, queryItem5, queryItem6]
//
//        SVProgressHUD.show()
//
//        if let url = urlComponents.url {
//            let request = AF.request(url)
//            request.responseJSON { (response) in
//                if let json = response.data {
//                    do{
//                        let data = try JSON(data: json)
//                        print(data)
//                        let statusCode = data["statusCode"].intValue
//                        let message = data["body"]["message"].stringValue
//                        if (statusCode == 200) {
//                            self.showError(text: message)
//                            SVProgressHUD.dismiss()
//                        } else {
//                            self.showError(text: message)
//                            SVProgressHUD.dismiss()
//                        }
//                        return
//                    } catch {
//                        print("JSON Error")
//                        SVProgressHUD.dismiss()
//                        self.showError(text: "JSON Parsing failed!")
//                        return
//                    }
//                } else {
//                   SVProgressHUD.dismiss()
//                   self.showError(text: "Creating user card failed!")
//               }
//            }
//        } else {
//            SVProgressHUD.dismiss()
//            self.showError(text: "Creating user card failed!")
//        }
    }

    @objc func topupTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let vc = R.storyboard.wallet().instantiateViewController(withIdentifier: "TopupViewController") as! TopupViewController
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    private func selectTabs() {
        lblTransactions.layer.sublayers?.removeAll()
        lblDeposits.layer.sublayers?.removeAll()
        lblExpenses.layer.sublayers?.removeAll()

        if (selectedTabIndex == 0) {
            addBottomBorder(label: lblTransactions)
        } else if (selectedTabIndex == 1) {
            addBottomBorder(label: lblDeposits)
        } else if (selectedTabIndex == 2) {
            addBottomBorder(label: lblExpenses)
        }

        reloadTableView()
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

    @objc func depositsTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        selectedTabIndex = 1
        selectTabs()
    }

    @objc func expensesTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        selectedTabIndex = 2
        selectTabs()
    }

    @objc func dismissRequestInfoTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        viewRequestInfo.isHidden = true
    }

    @objc func requestContentTapped(tapGestureRecognizer: UITapGestureRecognizer) {

    }

    func chargeMoney() {
        getBevyBalance()
    }

    func reloadTableView() {
        paymentsForTableView.removeAll()

        for index in 0..<AppConstants.shared.payments.count {
            let payment = AppConstants.shared.payments[index]
            let amount = payment.amount
            if (selectedTabIndex == 0) {
                if (payment.type != "autosaving") {
                    self.paymentsForTableView.append(payment)
                }
            } else if (selectedTabIndex == 1) {
                if (payment.type == "charge" || payment.type == "receive" || payment.type == "receiveforrequest" || payment.type == "cashout" ||  payment.type == "requestfromme") {
                    self.paymentsForTableView.append(payment)
                } else if (payment.type == "livetransaction" && amount! > 0) {
                    self.paymentsForTableView.append(payment)
                }
            } else if (selectedTabIndex == 2) {
                if (payment.type == "sent" || payment.type == "sentforrequest" || payment.type == "defaultsaving" || payment.type == "livespend" || payment.type == "requesttome") {
                    self.paymentsForTableView.append(payment)
                } else if (payment.type == "livetransaction" && amount! < 0) {
                    self.paymentsForTableView.append(payment)
                }
            }
        }

        self.tblTransactions.reloadData()
    }

    @IBAction func refreshClicked(_ sender: Any) {
        getBevyBalance()
    }

    @IBAction func requestApproveTapped(_ sender: Any) {
        self.viewRequestInfo.isHidden = true
        SVProgressHUD.show()

        let db = Firestore.firestore()
        db.collection("users").document(self.selectedPaymentItem!.senderID!).getDocument { (document, error) in
            if let error = error {
                SVProgressHUD.dismiss()
                self.showError(text: error.localizedDescription)
                return
            }

            SVProgressHUD.dismiss()

            let sender = User(JSON: document!.data()!)
            let vc = R.storyboard.wallet().instantiateViewController(withIdentifier: "WalletSendMoneyViewController") as! WalletSendMoneyViewController
            vc.fromRequestAccept = true
            vc.userInfo = sender
            vc.requestAmount = self.selectedPaymentItem!.amount!
            vc.requestID = self.selectedPaymentItem!.paymentID!
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }

    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentsForTableView.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as! TransactionTableViewCell
        let payment = paymentsForTableView[indexPath.row]
        let amount: Double = Double(payment.amount!) / Double(100.0)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.groupingSeparator = ","
        let formatted = formatter.string(from: NSNumber(value: amount >= 0 ? amount : amount * (-1) ))
        if (payment.type == "charge") {
            cell.lblBrand.text = payment.brand! + "    **** " + payment.last4!
            cell.lblLast4.text = "Charged"
            cell.lblStatus.text = payment.status?.capitalized
            cell.lblAmount.text = "+ $ " + formatted!
            cell.lblAmount.textColor = UIColor(rgb: 0x228B19)
        } else if (payment.type == "sent") {
            cell.lblBrand.text = payment.receiverUsername
            cell.lblLast4.text = "Money Sent"
            cell.lblStatus.text = ""
            cell.lblAmount.text = "- $ " + formatted!
            cell.lblAmount.textColor = UIColor(rgb: 0xD73A31)
        } else if (payment.type == "sentforrequest") {
            cell.lblBrand.text = "Cash Sent"
            cell.lblLast4.text = payment.receiverUsername
            cell.lblStatus.text = ""
            cell.lblAmount.text = "- $ " + formatted!
            cell.lblAmount.textColor = UIColor(rgb: 0xD73A31)
        } else if (payment.type == "receive") {
            cell.lblBrand.text = payment.senderUsername
            cell.lblLast4.text = "Received"
            cell.lblStatus.text = ""
            cell.lblAmount.text = "+ $ " + formatted!
            cell.lblAmount.textColor = UIColor(rgb: 0x228B19)
        } else if (payment.type == "receiveforrequest") {
            cell.lblBrand.text = "Cash Received"
            cell.lblLast4.text = payment.senderUsername
            cell.lblStatus.text = ""
            cell.lblAmount.text = "+ $ " + formatted!
            cell.lblAmount.textColor = UIColor(rgb: 0x228B19)
        } else if (payment.type == "defaultsaving") {
            cell.lblBrand.text = "Savings Deposit"
            cell.lblLast4.text = "Saved"
            cell.lblStatus.text = ""
            cell.lblAmount.text = "- $ " + formatted!
            cell.lblAmount.textColor = UIColor(rgb: 0xD73A31)
        } else if (payment.type == "cashout") {
            cell.lblBrand.text = "Savings Deposit"
            cell.lblLast4.text = "Cash out"
            cell.lblStatus.text = ""
            cell.lblAmount.text = "+ $ " + formatted!
            cell.lblAmount.textColor = UIColor(rgb: 0x228B19)
        } else if (payment.type == "livespend") {
            cell.lblBrand.text = payment.merchantName
            cell.lblLast4.text = "Spent"
            cell.lblStatus.text = ""
            cell.lblAmount.text = "- $ " + formatted!
            cell.lblAmount.textColor = UIColor(rgb: 0xD73A31)
        } else if (payment.type == "livetransaction") {
            cell.lblBrand.text = payment.merchantName
            cell.lblLast4.text = "Transaction"
            cell.lblStatus.text = ""
            if (amount > 0) {
                cell.lblAmount.text = "+ $ " + formatted!
                cell.lblAmount.textColor = UIColor(rgb: 0x228B19)
            } else {
                cell.lblAmount.text = "- $ " + formatted!
                cell.lblAmount.textColor = UIColor(rgb: 0xD73A31)
            }
        } else if (payment.type == "requestfromme") {
            cell.lblBrand.text = "Cash Request"
            cell.lblLast4.text = payment.receiverUsername
            cell.lblStatus.text = ""
            cell.lblAmount.text = "+ $ " + formatted!
            cell.lblAmount.textColor = UIColor(rgb: 0x228B19)
        } else if (payment.type == "requesttome") {
            cell.lblBrand.text = "Cash Request"
            cell.lblLast4.text = payment.senderUsername
            cell.lblStatus.text = ""
            cell.lblAmount.text = "- $ " + formatted!
            cell.lblAmount.textColor = UIColor(rgb: 0xD73A31)
        }

        let created = payment.createdAt!
//        let date = Date(timeIntervalSince1970: TimeInterval(created))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "MMM, dd"
        let today = Date()
        if (dateFormatter.string(from: created) == dateFormatter.string(from: today)) {
            cell.lblDate.text = "Today"
        } else {
            cell.lblDate.text = dateFormatter.string(from: created)
        }
        if (payment.type == "requestfromme" || payment.type == "requesttome") {
            cell.lblDate.text = "Pending"
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let payment = paymentsForTableView[indexPath.row]
        if (payment.type == "requesttome") {
            self.selectedPaymentItem = payment
            let amount: Double = Double(payment.amount!) / Double(100.0)
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            formatter.groupingSeparator = ","
            let formatted = formatter.string(from: NSNumber(value: amount >= 0 ? amount : amount * (-1) ))
            self.lblRequestAmount.text = "$" + formatted!
            self.lblRequestSender.text = payment.senderUsername
            self.viewRequestInfo.isHidden = false
        }
    }
}

