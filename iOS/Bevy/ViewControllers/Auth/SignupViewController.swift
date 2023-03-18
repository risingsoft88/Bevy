//
//  SignupViewController.swift
//  Bevy
//
//  Created by macOS on 6/18/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SVProgressHUD
import Alamofire
import SwiftyJSON
import GooglePlaces
import McPicker

class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSignin: UIButton!
    @IBOutlet weak var imgAvatar: UIImageView!

    @IBOutlet weak var editFirstname: UITextField!
    @IBOutlet weak var editLastname: UITextField!
    @IBOutlet weak var editName: UITextField!
    @IBOutlet weak var editEmail: UITextField!
    @IBOutlet weak var editPassword: UITextField!
    @IBOutlet weak var editAddressline1: UITextField!
    @IBOutlet weak var editCity: UITextField!
    @IBOutlet weak var editState: McTextField!
    @IBOutlet weak var editZip: UITextField!
    @IBOutlet weak var editPhoneOpti: UITextField!

    @IBOutlet weak var viewFirstname: UIView!
    @IBOutlet weak var viewLastname: UIView!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var lblTerms: UILabel!
    @IBOutlet weak var viewAddress1: UIView!
    @IBOutlet weak var viewCity: UIView!
    @IBOutlet weak var viewState: UIView!
    @IBOutlet weak var viewZip: UIView!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var viewAlreadyAccount: UIView!
    @IBOutlet weak var imgTermsAgree: UIImageView!

    let imagePicker = UIImagePickerController()
    var selectedImage : UIImage? = nil
    var hidePassword = true
    var hideRepassword = true
    var isAvatar = true
    var isTermsAgree = false
    
    var newUserType = ""
    var newFirstname = ""
    var newLastname = ""
    var newUserEmail = ""
    var newUserPwd = ""
    var newUsername = ""
    var newUserPhone = ""
    var newUserAddressline = ""
    var newUserCity = ""
    var newUserState = ""
    var newUserZip = ""
    var newUserPhotoUrl = ""
    
    var isLoading = false

    let stateData: [[String]] = [[
    "AK - Alaska",
    "AL - Alabama",
    "AR - Arkansas",
    "AS - American Samoa",
    "AZ - Arizona",
    "CA - California",
    "CO - Colorado",
    "CT - Connecticut",
    "DC - District of Columbia",
    "DE - Delaware",
    "FL - Florida",
    "GA - Georgia",
    "GU - Guam",
    "HI - Hawaii",
    "IA - Iowa",
    "ID - Idaho",
    "IL - Illinois",
    "IN - Indiana",
    "KS - Kansas",
    "KY - Kentucky",
    "LA - Louisiana",
    "MA - Massachusetts",
    "MD - Maryland",
    "ME - Maine",
    "MI - Michigan",
    "MN - Minnesota",
    "MO - Missouri",
    "MS - Mississippi",
    "MT - Montana",
    "NC - North Carolina",
    "ND - North Dakota",
    "NE - Nebraska",
    "NH - New Hampshire",
    "NJ - New Jersey",
    "NM - New Mexico",
    "NV - Nevada",
    "NY - New York",
    "OH - Ohio",
    "OK - Oklahoma",
    "OR - Oregon",
    "PA - Pennsylvania",
    "PR - Puerto Rico",
    "RI - Rhode Island",
    "SC - South Carolina",
    "SD - South Dakota",
    "TN - Tennessee",
    "TX - Texas",
    "UT - Utah",
    "VA - Virginia",
    "VI - Virgin Islands",
    "VT - Vermont",
    "WA - Washington",
    "WI - Wisconsin",
    "WV - West Virginia",
    "WY - Wyoming"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let mcInputView = McPicker(data: stateData)
        mcInputView.backgroundColor = .gray
        mcInputView.backgroundColorAlpha = 0.25
        editState.inputViewMcPicker = mcInputView
        editState.doneHandler = { [weak editState] (selections) in
            self.editState?.text = selections[0]!
        }
        editState.selectionChangedHandler = { [weak editState] (selections, componentThatChanged) in
            self.editState?.text = selections[componentThatChanged]!
        }
        editState.cancelHandler = { [weak editState] in
//            self.editState?.text = ""
        }
        editState.textFieldWillBeginEditingHandler = { [weak editState] (selections) in
            if self.editState?.text == "" {
                // Selections always default to the first value per component
                self.editState?.text = selections[0]
            }
        }
        
        imgAvatar.layer.cornerRadius = imgAvatar.frame.width/2
        btnSignin.layer.cornerRadius = 10

        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgAvatar.isUserInteractionEnabled = true
        imgAvatar.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(termsTapped(tapGestureRecognizer:)))
        lblTerms.isUserInteractionEnabled = true
        lblTerms.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(termsAgreeTapped(tapGestureRecognizer:)))
        imgTermsAgree.isUserInteractionEnabled = true
        imgTermsAgree.addGestureRecognizer(tapGestureRecognizer)

        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        editPassword.isSecureTextEntry = hidePassword

        isTermsAgree = false
        switchTermsAgree()
        
        if (newUserType == "email") {
            editFirstname.text = newFirstname
            editLastname.text = newLastname
            editEmail.text = newUserEmail
            editEmail.isUserInteractionEnabled = false
            editPassword.text = newUserPwd
            editPassword.isUserInteractionEnabled = false
            editName.text = newUsername
            editPhoneOpti.text = newUserPhone
            editAddressline1.text = newUserAddressline
            editCity.text = newUserCity
            editState.text = newUserState
            editZip.text = newUserZip
            Utils.loadUserAvatar(imgAvatar, url: newUserPhotoUrl)
            viewAlreadyAccount.isHidden = true
        } else if (newUserType == "facebook" || newUserType == "twitter" || newUserType == "google" || newUserType == "apple") {
            editFirstname.text = newFirstname
            editLastname.text = newLastname
            editEmail.text = newUserEmail
            if (newUserType != "twitter") {
                editEmail.isUserInteractionEnabled = false
            }
            editPassword.text = "********"
            editPassword.isUserInteractionEnabled = false
            editName.text = newUsername
            if (newUsername != "") {
                editName.isUserInteractionEnabled = false
            }
            editPhoneOpti.text = newUserPhone
            editAddressline1.text = newUserAddressline
            editCity.text = newUserCity
            editState.text = newUserState
            editZip.text = newUserZip
            Utils.loadUserAvatar(imgAvatar, url: newUserPhotoUrl)
            viewAlreadyAccount.isHidden = true
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        viewFirstname.addBottomBorderWithColor(color: UIColor(rgb: 0xD8D8D8), width: 2)
        viewLastname.addBottomBorderWithColor(color: UIColor(rgb: 0xD8D8D8), width: 2)
        viewName.addBottomBorderWithColor(color: UIColor(rgb: 0xD8D8D8), width: 2)
        viewEmail.addBottomBorderWithColor(color: UIColor(rgb: 0xD8D8D8), width: 2)
        viewPassword.addBottomBorderWithColor(color: UIColor(rgb: 0xD8D8D8), width: 2)
        viewAddress1.addBottomBorderWithColor(color: UIColor(rgb: 0xD8D8D8), width: 2)
        viewCity.addBottomBorderWithColor(color: UIColor(rgb: 0xD8D8D8), width: 2)
        viewState.addBottomBorderWithColor(color: UIColor(rgb: 0xD8D8D8), width: 2)
        viewZip.addBottomBorderWithColor(color: UIColor(rgb: 0xD8D8D8), width: 2)
        viewPhone.addBottomBorderWithColor(color: UIColor(rgb: 0xD8D8D8), width: 2)
    }

    @IBAction func addresslineTapped(_ sender: Any) {
        if (isLoading) {
            return
        }
        editAddressline1.resignFirstResponder()
        let filter = GMSAutocompleteFilter()
        filter.country = "USA"
        filter.type = .address
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        acController.autocompleteFilter = filter
        present(acController, animated: true, completion: nil)
    }
    
    @IBAction func backClicked(_ sender: Any) {
        if (isLoading) {
            return
        }
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func stateClicked(_ sender: Any) {
    }

    @IBAction func loginClicked(_ sender: Any) {
        if (isLoading) {
            return
        }
        let vc = R.storyboard.sub().instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func showPasswordClicked(_ sender: Any) {
        if (newUserType == "facebook" || newUserType == "twitter" || newUserType == "google" || newUserType == "apple") {
            return
        }
        if (isLoading) {
            return
        }
        hidePassword = !hidePassword
        editPassword.isSecureTextEntry = hidePassword
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if (isLoading) {
            return
        }
        isAvatar = true
        let alert: UIAlertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: .default) {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            UIAlertAction in
        }

        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    func switchTermsAgree() {
        if (self.isTermsAgree) {
            self.imgTermsAgree.image = R.image.icon_checkbox_on()
        } else {
            self.imgTermsAgree.image = R.image.icon_checkbox_off()
        }
    }

    @objc func termsAgreeTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if (isLoading) {
            return
        }
        self.isTermsAgree = !self.isTermsAgree
        switchTermsAgree()
    }

    @objc func termsTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if (isLoading) {
            return
        }
        let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let termsAction = UIAlertAction(title: "Terms and Conditions", style: .default) {
            UIAlertAction in
            self.selectTerms(index: 0)
        }
        let copyrightAction = UIAlertAction(title: "Copyright Policy", style: .default) {
            UIAlertAction in
            self.selectTerms(index: 1)
        }
        let privacyAction = UIAlertAction(title: "Privacy Policy", style: .default) {
            UIAlertAction in
            self.selectTerms(index: 2)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            UIAlertAction in
        }

        // Add the actions
        alert.addAction(termsAction)
        alert.addAction(copyrightAction)
        alert.addAction(privacyAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    func selectTerms(index: Int) {
        let vc = R.storyboard.sub().instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
        vc.modalPresentationStyle = .fullScreen
        vc.type = index // 0: "Terms &\nConditions", 1: "Copyright\nPolicy", 2: "Privacy\nPolicy"
        self.present(vc, animated: true, completion: nil)
    }

    func openCamera() {
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            self.showAlert("You don't have camera.")
        }
    }

    func openGallary() {
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }

    private func showErrorAndHideProgress(text: String) {
        SVProgressHUD.dismiss()
        isLoading = false
        self.showError(text: text)
    }

    private func createBevyCard(user: User) {
        //http://localhost:5001/bevy-b3121/us-central1/createBevyCard?username=username&email=email&phone_number=phone_number&line1=line1&city=city&state=state&postal_code=postal_code
        //https://us-central1-bevy-b3121.cloudfunctions.net/createBevyCard?username=username&email=email&phone_number=phone_number&line1=line1&city=city&state=state&postal_code=postal_code

        let name = user.firstname! + " " + user.lastname!
        let scheme = "https"
        let host = "us-central1-bevy-b3121.cloudfunctions.net"
        let path = "/createBevyCard"
        let queryItem0 = URLQueryItem(name: "userid", value: String(user.userID!))
        let queryItem1 = URLQueryItem(name: "username", value: String(name))
        let queryItem2 = URLQueryItem(name: "email", value: String(user.email!))
        let queryItem3 = URLQueryItem(name: "phone_number", value: String(user.phone!))
        let queryItem4 = URLQueryItem(name: "line1", value: String(user.addressline1!))
        let queryItem5 = URLQueryItem(name: "city", value: String(user.city!))
        let queryItem6 = URLQueryItem(name: "state", value: String(user.state!))
        let queryItem7 = URLQueryItem(name: "postal_code", value: String(user.zip!))

        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [queryItem0, queryItem1, queryItem2, queryItem3, queryItem4, queryItem5, queryItem6, queryItem7]

        if let url = urlComponents.url {
            let request = AF.request(url)
            request.responseJSON { (response) in
                if let json = response.data {
                    do{
                        let data = try JSON(data: json)
                        let statusCode = data["statusCode"].intValue
                        let message = data["body"]["message"].stringValue
                        let cardID = data["body"]["cardID"].stringValue
                        let cardNumber = data["body"]["cardNumber"].stringValue
                        if (statusCode == 200) {
                            guard let currentUser = Auth.auth().currentUser else {
                                self.showErrorAndHideProgress(text: "User authentication failed!")
                                return
                            }

                            currentUser.reload { (error) in
                                if let error = error {
                                    self.showErrorAndHideProgress(text: error.localizedDescription)
                                    return
                                }

                                user.cardID = cardID;
                                user.cardNumber = cardNumber;

                                if (Auth.auth().currentUser!.isEmailVerified || self.newUserType == "facebook" || self.newUserType == "twitter" || self.newUserType == "google" || self.newUserType == "apple") {
                                    SVProgressHUD.dismiss()
                                    self.isLoading = false
                                    
                                    if let token = Messaging.messaging().fcmToken {
                                        AppManager.shared.currentUserRef!.setData(["fcmToken": token], merge: true)
                                        user.fcmToken = token;
                                    }

                                    AppManager.shared.saveCurrentUser(user: user)
                                    
                                    let defaults = UserDefaults.standard
                                    if (self.newUserType == "") {
                                        defaults.set(user.email, forKey: "useremail")
                                        defaults.set(user.password, forKey: "userpwd")
                                    }

                                    let skipOnboarding = defaults.string(forKey: "skipOnboarding") ?? ""
                                    if (skipOnboarding == "skip") {
                                        let vc = R.storyboard.auth().instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
                                        vc.modalPresentationStyle = .fullScreen
                                        self.present(vc, animated: true, completion: nil)
                                    } else {
                                        let vc = R.storyboard.auth().instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
                                        vc.modalPresentationStyle = .fullScreen
                                        self.present(vc, animated: true, completion: nil)
                                    }
                                } else {
                                    Auth.auth().currentUser?.sendEmailVerification { (error) in
                                        if let error = error {
                                            self.showErrorAndHideProgress(text: error.localizedDescription)
                                            return
                                        }

                                        SVProgressHUD.dismiss()
                                        self.isLoading = false

                                        let alertController = UIAlertController(title: "Sent verification email, please verify your email address!", message: nil, preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                                            let defaults = UserDefaults.standard
                                            defaults.set("", forKey: "remember")
                                            defaults.set("", forKey: "useremail")
                                            defaults.set("", forKey: "userpwd")
                                            let vc = R.storyboard.auth().instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                                            vc.modalPresentationStyle = .fullScreen
                                            self.present(vc, animated: true, completion: nil)
                                        }
                                        alertController.addAction(okAction)
                                        self.present(alertController, animated: true)
                                    }
                                }
                            }
                        } else {
                            self.showError(text: message)
                            SVProgressHUD.dismiss()
                            self.isLoading = false
                        }
                        return
                    } catch {
                        print("JSON Error")
                        SVProgressHUD.dismiss()
                        self.isLoading = false
                        self.showError(text: "JSON Parsing failed!")
                        return
                    }
                } else {
                    SVProgressHUD.dismiss()
                    self.isLoading = false
                    self.showError(text: "Creating user card failed!")
               }
            }
        } else {
            SVProgressHUD.dismiss()
            self.isLoading = false
            self.showError(text: "Creating user card failed!")
        }
    }

    @IBAction func signinClicked(_ sender: Any) {
        if (isLoading) {
            return
        }
        guard let firstname = editFirstname.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let lastname = editLastname.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let username = editName.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let email = editEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let password = editPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let addressline1 = editAddressline1.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let city = editCity.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let state = editState.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let zip = editZip.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let phone = editPhoneOpti.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }

        if firstname.isEmpty {
            showAlert("Please enter a first name!")
            return
        }
        
        if lastname.isEmpty {
            showAlert("Please enter a last name!")
            return
        }

        if username.isEmpty {
            showAlert("Please enter a valid username!")
            return
        }

        if (newUserType == "" || newUserType == "twitter") {
            if !email.isValidEmail() {
                showAlert("Please enter a valid email address!")
                return
            }
        }

        if phone.isEmpty {
            showAlert("Please enter a valid phone number!")
            return
        }

        if (newUserType == "") {
            if !password.isValidPassword() {
                showAlert("Please enter a password with 6 or more characters!")
                return
            }
        }

        if addressline1.isEmpty {
            showAlert("Please enter a valid address line!")
            return
        }

        if city.isEmpty {
            showAlert("Please enter a valid city!")
            return
        }

        if state.isEmpty {
            showAlert("Please enter a valid state!")
            return
        }
        let stateCode = String(state.prefix(2))

        if zip.isEmpty {
            showAlert("Please enter a valid zip!")
            return
        }

        if !self.isTermsAgree {
            showAlert("Please agree terms and conditions, copyright and privacy policy.")
            return
        }

        let alertController = UIAlertController(title: "Are you sure want to create?", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // cancel action
        }
        alertController.addAction(cancelAction)
        let okAction = UIAlertAction(title: "Create", style: .default) { (action) in
            self.isLoading = true
            SVProgressHUD.show()

            let db = Firestore.firestore()

            if self.newUserType != "" {
                guard let currentUser = Auth.auth().currentUser else {
                    self.showErrorAndHideProgress(text: "Unknown Error!")
                    return
                }

                var newUserDocRef: DocumentReference
                newUserDocRef = db.collection("users").document(currentUser.uid)

                let newUser = User()
                newUser.userID = newUserDocRef.documentID
                newUser.firstname = firstname
                newUser.lastname = lastname
                newUser.username = username
                newUser.email = email
                if (self.newUserType == "facebook" || self.newUserType == "twitter" || self.newUserType == "google" || self.newUserType == "apple") {
                    newUser.password = ""
                } else {
                    newUser.password = password
                }
                newUser.userType = self.newUserType
                newUser.phone = phone
                newUser.gender = ""
                newUser.addressline1 = addressline1
                newUser.city = city
                newUser.state = stateCode
                newUser.zip = zip
                newUser.savedAmount = 0
                newUser.cardID = ""
                newUser.cardNumber = ""
                newUser.availableAmount = 0
                newUser.photoUrl = self.newUserPhotoUrl
                newUser.createdAt = Date()

                AppManager.shared.saveCurrentUserRef(userRef: newUserDocRef)

                newUserDocRef.setData(newUser.toJSON()) { error in
                    if let error = error {
                        self.showErrorAndHideProgress(text: error.localizedDescription)
                        return
                    }

                    if (self.selectedImage != nil) {
                        let storage = Storage.storage()
                        let storageRef = storage.reference()
                        let data = self.selectedImage?.jpegData(compressionQuality: 0.8)
                        guard let userID = AppManager.shared.currentUser?.userID else {
                            self.showErrorAndHideProgress(text: "There was an error uploading profile photo. Please try again.")
                            return
                        }
                        let avatarRef = storageRef.child("avatars/\(userID).png")
                        _ = avatarRef.putData(data!, metadata: nil) { (metadata, error) in
                            guard metadata != nil else {
                                self.showErrorAndHideProgress(text: "There was an error uploading profile photo. Please try again.")
                                return
                            }
                            avatarRef.downloadURL { (url, error) in
                                guard let downloadURL = url else {
                                    self.showErrorAndHideProgress(text: "There was an error uploading profile photo. Please try again.")
                                    return
                                }

                                newUser.photoUrl = downloadURL.absoluteString
                                newUserDocRef.updateData(["photoUrl": downloadURL.absoluteString]);

                                self.createBevyCard(user: newUser)
                            }
                        }
                    } else {
                        self.createBevyCard(user: newUser)
                    }
                }
                return
            }

            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if let error = error {
                    if (error.localizedDescription == "The email address is already in use by another account.") {
                        SVProgressHUD.dismiss()
                        self.isLoading = false
                        let alertController = UIAlertController(title: "The email address is already in use by exist account.", message: nil, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                            let vc = R.storyboard.auth().instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                        }
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true)
                        return
                    }
                    self.showErrorAndHideProgress(text: error.localizedDescription)
                    return
                }

                guard let authResult = authResult else {
                    self.showErrorAndHideProgress(text: "There was an error signing up. Please try again.")
                    return
                }

                let authUser: Firebase.User = authResult.user
                let userID = authUser.uid

                db.collection("users").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
                    if let error = error {
                        self.showErrorAndHideProgress(text: error.localizedDescription)
                        return
                    }

                    guard let snapshot = querySnapshot else {
                        self.showErrorAndHideProgress(text: "There was an error signing up. Please try again.")
                        return
                    }

                    // User exists with the specified email, show error
                    if snapshot.documents.first != nil {
                        self.showErrorAndHideProgress(text: "Email already taken")
                        return
                    }

                    var newUserDocRef: DocumentReference
                    newUserDocRef = db.collection("users").document(userID)

                    let newUser = User()
                    newUser.userID = newUserDocRef.documentID
                    newUser.firstname = firstname
                    newUser.lastname = lastname
                    newUser.username = username
                    newUser.email = email
                    newUser.password = password
                    newUser.userType = "email"
                    newUser.phone = phone
                    newUser.gender = ""
                    newUser.addressline1 = addressline1
                    newUser.city = city
                    newUser.state = stateCode
                    newUser.zip = zip
                    newUser.savedAmount = 0
                    newUser.cardID = ""
                    newUser.cardNumber = ""
                    newUser.availableAmount = 0
                    newUser.createdAt = Date()

                    AppManager.shared.saveCurrentUserRef(userRef: newUserDocRef)

                    newUserDocRef.setData(newUser.toJSON()) { error in
                        if let error = error {
                            self.showErrorAndHideProgress(text: error.localizedDescription)
                            return
                        }

                        if (self.selectedImage != nil) {
                            let storage = Storage.storage()
                            let storageRef = storage.reference()
                            let data = self.selectedImage?.jpegData(compressionQuality: 0.8)
                            guard let userID = AppManager.shared.currentUser?.userID else {
                                self.showErrorAndHideProgress(text: "There was an error uploading profile photo. Please try again.")
                                return
                            }
                            let avatarRef = storageRef.child("avatars/\(userID).png")
                            _ = avatarRef.putData(data!, metadata: nil) { (metadata, error) in
                                guard metadata != nil else {
                                    self.showErrorAndHideProgress(text: "There was an error uploading profile photo. Please try again.")
                                    return
                                }
                                avatarRef.downloadURL { (url, error) in
                                    guard let downloadURL = url else {
                                        self.showErrorAndHideProgress(text: "There was an error uploading profile photo. Please try again.")
                                        return
                                    }

                                    newUser.photoUrl = downloadURL.absoluteString
                                    newUserDocRef.updateData(["photoUrl": downloadURL.absoluteString]);

                                    self.createBevyCard(user: newUser)
                                }
                            }
                        } else {
                            self.createBevyCard(user: newUser)
                        }
                    }
                }
            }
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }

    //MARK:- UIImagePickerViewDelegate.
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) { [weak self] in
            guard let image = info[.editedImage] as? UIImage else { return }
            if (self!.isAvatar) {
                self?.selectedImage = image
                self?.imgAvatar.image = image
            }
        }
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
}

extension SignupViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get the place name from 'GMSAutocompleteViewController'
        // Then display the name in textField
        editAddressline1.text = place.name // place.formattedAddress
        for component in place.addressComponents! {
            for type in (component.types){
                if type == "locality" {
                    editCity.text = component.name
                } else if type == "postal_code" {
                    editZip.text = component.name
                } else if type == "administrative_area_level_1" {
                    for stateNameArray in stateData {
                        for stateName in stateNameArray {
                            if (String(stateName.prefix(2)) == component.shortName) {
                                editState.text = stateName
                            }
                        }
                    }
                }
            }
        }
        // Dismiss the GMSAutocompleteViewController when something is selected
        dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
        print("Error: ", error.localizedDescription)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
    }
}
