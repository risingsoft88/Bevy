//
//  SavingsViewController.swift
//  Bevy
//
//  Created by macOS on 9/3/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import SVProgressHUD
import Alamofire
import SwiftyJSON

class SavingsViewController: BaseSubViewController, UITableViewDataSource, UITableViewDelegate, CreateSavingsViewControllerDelegate {

    @IBOutlet weak var tblSavings: UITableView!
    @IBOutlet weak var lblCurrentSaving: UILabel!

    var savings: [Savings] = []
    var paymentSavings: [PaymentSaving] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tblSavings.dataSource = self
        tblSavings.delegate = self
        tblSavings.register(R.nib.savingsTableViewCell)
        tblSavings.register(R.nib.savingsHeaderTableViewCell)

        self.lblCurrentSaving.text = "Current Savings : $0.0"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if (self.isBeingPresented || self.isMovingToParent) {
            getSavings()
        }
    }

    private func showErrorAndHideProgress(text: String) {
        SVProgressHUD.dismiss()
        self.showError(text: text)
    }

    @IBAction func createClicked(_ sender: Any) {
        let vc = R.storyboard.wallet().instantiateViewController(withIdentifier: "CreateSavingsViewController") as! CreateSavingsViewController
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func clickedCashOut(_ sender: Any) {
        let amount = AppManager.shared.currentUser!.savedAmount!

        let intAmount = Int(amount)

        if intAmount == 0 {
            showAlert("Saving amount is not valid.")
            return
        }

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

                if (currentUser!.savedAmount! <= 0) {
                    SVProgressHUD.dismiss()
                    self.showError(text: "Saving amount is not valid.")
                    return
                }

                // https://us-central1-bevy-b3121.cloudfunctions.net/createCashout?userid=userid&amount=amount&type=type&createdAt=createdAt

                let scheme = "https"
                let host = "us-central1-bevy-b3121.cloudfunctions.net"
                let path = "/createCashout"
                let queryItem0 = URLQueryItem(name: "userid", value: AppManager.shared.currentUser!.userID!)
                let queryItem1 = URLQueryItem(name: "amount", value: String(intAmount))
                let queryItem2 = URLQueryItem(name: "type", value: "cashout")
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
                                let availableAmount = data["body"]["availableAmount"].intValue
                                SVProgressHUD.dismiss()
                                if (statusCode == 200) {
                                    AppManager.shared.currentUser!.availableAmount! = availableAmount
                                    AppManager.shared.currentUser!.savedAmount! = 0
                                    self.lblCurrentSaving.text = "Current Savings : $0.0"
                                    AppConstants.shared.isDirtyBalance = true
                                    self.dismiss(animated: true, completion: nil)
                                    NotificationCenter.default.post(name: NSNotification.Name("com.dirty.balance"), object: nil)
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

    func createSaving() {
        getSavings()
    }

    func getSavings() {
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

            db.collection("paymentsavings").whereField("userID", isEqualTo: AppManager.shared.currentUser!.userID!).getDocuments { (querySnapshot, error) in
                if let error = error {
                    self.showErrorAndHideProgress(text: error.localizedDescription)
                    return
                }

                SVProgressHUD.dismiss()

                self.paymentSavings.removeAll()
                for document in querySnapshot!.documents {
                    let savingInfo = PaymentSaving(JSON: document.data())
                    self.paymentSavings.append(savingInfo!)
                }

                self.loadSavings()
            }
        }
    }

    private func loadSavings() {
        self.view.layoutIfNeeded()

        let amount: Double = Double(AppManager.shared.currentUser!.savedAmount!) / Double(100.0)
        lblCurrentSaving.text = "Current Savings : $" + String(amount)

        savings.removeAll()

        paymentSavings.sort(by: { $0.createdAt!.compare($1.createdAt!) == ComparisonResult.orderedDescending })
        var lastDate = ""
        for index in 0..<paymentSavings.count {
            let paymentSaving = paymentSavings[index]
            let amount: Double = Double(paymentSaving.amount!) / Double(100.0)
            let created = paymentSaving.createdAt!
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = NSTimeZone.local
            dateFormatter.dateFormat = "dd MMM yyyy"
            let today = Date()
            var strCreatedAt = dateFormatter.string(from: created)
            if (strCreatedAt == dateFormatter.string(from: today)) {
                strCreatedAt = "Today"
            }
            if (strCreatedAt != lastDate) {
                let saving = Savings()
                saving.title = strCreatedAt
                saving.amount = ""
                self.savings.append(saving)
                lastDate = strCreatedAt
            }
            let saving = Savings()
            saving.title = paymentSaving.type == "defaultsaving" ? "Default Savings Deposit" : "Auto Savings Deposit"
            saving.amount = "$" + String(amount) + " USD"
            self.savings.append(saving)
        }

        self.tblSavings.reloadData()
    }

    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isHeader = savings[indexPath.row].amount
        if (isHeader == "") {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SavingsHeaderTableViewCell", for: indexPath) as! SavingsHeaderTableViewCell
            cell.lblDate.text = savings[indexPath.row].title
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SavingsTableViewCell", for: indexPath) as! SavingsTableViewCell
            cell.lblTitle.text = savings[indexPath.row].title
            cell.lblAmount.text = savings[indexPath.row].amount
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//
//        AppConstants.shared.nRightMenuSelectedIndex = indexPath.row
//
//        let strController = AppConstants.shared.rightMenuViewControllers[AppConstants.shared.nLeftMenuSelectedIndex][indexPath.row]
//        var storyboard : UIStoryboard
//        if (AppConstants.shared.nLeftMenuSelectedIndex == 0) {
//            storyboard = R.storyboard.social()
//        } else if (AppConstants.shared.nLeftMenuSelectedIndex == 1) {
//            storyboard = R.storyboard.wallet()
//        } else {
//            storyboard = R.storyboard.sub()
//        }
//        if (strController == "MainViewController" || strController == "SupportViewController") {
//            storyboard = R.storyboard.sub()
//        }
//        let viewController = storyboard.instantiateViewController(withIdentifier: strController)
//        presentViewController(viewController: viewController)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let isHeader = savings[indexPath.row].amount
        if (isHeader == "") {
            return 32
        }
        return 44
    }
}
