//
//  ContactAddViewController.swift
//  Bevy
//
//  Created by macOS on 9/5/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import SVProgressHUD

protocol ContactAddViewControllerDelegate : NSObjectProtocol{
    func refreshContacts()
}

class ContactAddViewController: BaseSubViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    weak var delegate : ContactAddViewControllerDelegate?

    var users: [User] = []
    var filteredUsers: [User] = []
    var contacts: [User] = []

    @IBOutlet weak var tblContacts: UITableView!
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var imgSearchClear: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        searchText.delegate = self
        tblContacts.dataSource = self
        tblContacts.delegate = self
        tblContacts.register(R.nib.contactItemTableViewCell)

        self.view.layoutIfNeeded()

        let tapRemember = UITapGestureRecognizer(target: self, action: #selector(clearSearchClicked))
        imgSearchClear.isUserInteractionEnabled = true
        imgSearchClear.addGestureRecognizer(tapRemember)
    }

    private func showErrorAndHideProgress(text: String) {
        SVProgressHUD.dismiss()
        self.showError(text: text)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if (self.isBeingPresented || self.isMovingToParent) {
            SVProgressHUD.show()

            let db = Firestore.firestore()
            db.collection("users").getDocuments { (querySnapshot, error) in
                if let error = error {
                    self.showErrorAndHideProgress(text: error.localizedDescription)
                    return
                }

                SVProgressHUD.dismiss()

                self.users.removeAll()
                for document in querySnapshot!.documents {
                    let userInfo = User(JSON: document.data())
                    if (userInfo?.userID != AppManager.shared.currentUser?.userID) {
                        var bFlag = false
                        for index in 0..<self.contacts.count {
                            if (userInfo?.userID == self.contacts[index].userID) {
                                bFlag = true
                                break
                            }
                        }
                        if (!bFlag) {
                            self.users.append(userInfo!)
                        }
                    }
                }

                self.filterUserArray(searchString: "")
                if (self.users.count <= 0) {
                    self.showAlert("There is no contacts to add.")
                }
            }
        }
    }

    @objc func clearSearchClicked() {
        self.searchText.text = ""
        filterUserArray(searchString: "")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       searchText.resignFirstResponder()
       return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let string1 = string
        let string2 = searchText.text
        var finalString = ""
        if string.count > 0 {
            finalString = string2! + string1
        } else if string2!.count > 0 {
            finalString = String(string2!.dropLast())
        }
        filterUserArray(searchString: finalString)
        return true
    }

    func filterUserArray(searchString: String) {
        self.filteredUsers.removeAll()
        for index in 0..<self.users.count {
            if searchString.isEmpty {
                self.filteredUsers.append(self.users[index])
            } else if self.users[index].username!.lowercased().contains(searchString.lowercased()) {
                self.filteredUsers.append(self.users[index])
//            } else if self.users[index].email!.lowercased().contains(searchString.lowercased()) {
//                self.filteredUsers.append(self.users[index])
            }
        }
        tblContacts.reloadData()
    }

    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactItemTableViewCell", for: indexPath) as! ContactItemTableViewCell
        Utils.loadUserAvatar(cell.imgAvatar, url: filteredUsers[indexPath.row].photoUrl ?? "")
        cell.lblName.text = filteredUsers[indexPath.row].username ?? ""
//        cell.lblMsg.text = filteredUsers[indexPath.row].email ?? ""
        cell.btnAction.setTitle("Add", for: .normal)
        let sender = MyTapGesture(target: self, action: #selector(addContactTapped(sender:)))
        sender.selectedIndex = indexPath.row
        cell.btnAction.isUserInteractionEnabled = true
        cell.btnAction.addGestureRecognizer(sender)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @objc func addContactTapped(sender: MyTapGesture) {
        let alertController = UIAlertController(title: "Are you sure want to add?", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // cancel action
        }
        alertController.addAction(cancelAction)
        let okAction = UIAlertAction(title: "Add", style: .default) { (action) in
            SVProgressHUD.show()
            let db = Firestore.firestore()
            var newContactDocRef: DocumentReference
            newContactDocRef = db.collection("contacts").document()

            let newContact = Contact()
            newContact.ownerID = AppManager.shared.currentUser?.userID
            newContact.contactID = self.filteredUsers[sender.selectedIndex].userID
            newContact.createdAt = Date()

            newContactDocRef.setData(newContact.toJSON()) { error in
                if let error = error {
                    self.showErrorAndHideProgress(text: error.localizedDescription)
                    return
                }

                SVProgressHUD.dismiss()
                self.dismiss(animated: true, completion: nil)
                self.delegate?.refreshContacts()
            }
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }

    class MyTapGesture: UITapGestureRecognizer {
        var selectedIndex = 0
    }
}
