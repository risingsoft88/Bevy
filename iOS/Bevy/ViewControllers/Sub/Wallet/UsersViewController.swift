//
//  UsersViewController.swift
//  Bevy
//
//  Created by macOS on 11/24/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import Alamofire
import SVProgressHUD
import SwiftyJSON

class UsersViewController: BaseSubViewController, UITableViewDataSource, UITableViewDelegate, WalletSendMoneyViewControllerDelegate, ContactAddViewControllerDelegate {

    var isRequest = false
    var contacts: [User] = []

    @IBOutlet weak var tblContacts: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tblContacts.dataSource = self
        tblContacts.delegate = self
        tblContacts.register(R.nib.contactItemTableViewCell)

        self.view.layoutIfNeeded()
        //to call viewDidLayoutSubviews() and get dynamic width and height of scrollview
    }

    private func showErrorAndHideProgress(text: String) {
        SVProgressHUD.dismiss()
        self.showError(text: text)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if (self.isBeingPresented || self.isMovingToParent) {
            refreshContacts()
        }
    }

    @IBAction func addTapped(_ sender: Any) {
        let vc = R.storyboard.wallet().instantiateViewController(withIdentifier: "ContactAddViewController") as! ContactAddViewController
        vc.delegate = self
        vc.contacts = self.contacts
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    func refreshContacts() {
        guard let userID = AppManager.shared.currentUser?.userID else {
            return
        }

        let scheme = "https"
        let host = "us-central1-bevy-b3121.cloudfunctions.net"
        let path = "/getUserContacts"
        let queryItem0 = URLQueryItem(name: "userid", value: userID)

        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [queryItem0]

        if let url = urlComponents.url {

            SVProgressHUD.show()

            let request = AF.request(url)
            request.responseJSON { (response) in
                if let json = response.data {
                    do{
                        let data = try JSON(data: json)
                        let statusCode = data["statusCode"].intValue
                        let message = data["body"]["message"].stringValue

                        SVProgressHUD.dismiss()
                        if (statusCode == 200) {
                            if let arrayUser = data["body"]["users"].arrayObject {
                                self.contacts.removeAll()
                                for index in 0..<arrayUser.count {
                                    let userInfo = User(JSON: arrayUser[index] as! [String : Any])
                                    self.contacts.append(userInfo!)
                                }
                            }
                            self.tblContacts.reloadData()
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
        }
    }

    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactItemTableViewCell", for: indexPath) as! ContactItemTableViewCell
        Utils.loadUserAvatar(cell.imgAvatar, url: contacts[indexPath.row].photoUrl ?? "")
        cell.lblName.text = contacts[indexPath.row].username ?? ""
//        cell.lblMsg.text = contacts[indexPath.row].email ?? ""
        cell.btnAction.setTitle("Remove", for: .normal)
        let sender = MyTapGesture(target: self, action: #selector(removeContactTapped(sender:)))
        sender.selectedIndex = indexPath.row
        cell.btnAction.isUserInteractionEnabled = true
        cell.btnAction.addGestureRecognizer(sender)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let vc = R.storyboard.wallet().instantiateViewController(withIdentifier: "WalletSendMoneyViewController") as! WalletSendMoneyViewController
        vc.delegate = self
        vc.userInfo = contacts[indexPath.row]
        vc.isRequest = self.isRequest
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    @objc func removeContactTapped(sender: MyTapGesture) {
        let alertController = UIAlertController(title: "Are you sure want to remove?", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // cancel action
        }
        alertController.addAction(cancelAction)
        let okAction = UIAlertAction(title: "Remove", style: .default) { (action) in
            guard let userID = AppManager.shared.currentUser?.userID else {
                return
            }

            let scheme = "https"
            let host = "us-central1-bevy-b3121.cloudfunctions.net"
            let path = "/delUserContact"
            let queryItem0 = URLQueryItem(name: "ownerid", value: userID)
            let queryItem1 = URLQueryItem(name: "contactid", value: self.contacts[sender.selectedIndex].userID)

            var urlComponents = URLComponents()
            urlComponents.scheme = scheme
            urlComponents.host = host
            urlComponents.path = path
            urlComponents.queryItems = [queryItem0, queryItem1]

            if let url = urlComponents.url {

                SVProgressHUD.show()

                let request = AF.request(url)
                request.responseJSON { (response) in
                    if let json = response.data {
                        do{
                            let data = try JSON(data: json)
                            let statusCode = data["statusCode"].intValue
                            let message = data["body"]["message"].stringValue

                            SVProgressHUD.dismiss()
                            if (statusCode == 200) {
                                self.contacts.remove(at: sender.selectedIndex)
                                self.tblContacts.reloadData()
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
            }
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
    func gotoDashboard() {
        self.dismiss(animated: true, completion: nil)
    }
    
    class MyTapGesture: UITapGestureRecognizer {
        var selectedIndex = 0
    }
}
