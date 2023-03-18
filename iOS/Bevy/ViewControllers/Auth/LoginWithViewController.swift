//
//  LoginWithViewController.swift
//  Bevy
//
//  Created by macOS on 6/18/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import GoogleSignIn
import SVProgressHUD
import AuthenticationServices
import FBSDKCoreKit
import FBSDKLoginKit

#if canImport(CryptoKit)
import CryptoKit
@available(iOS 13, *)
private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
    return String(format: "%02x", $0)
}.joined()

return hashString
}#else
import CommonCrypto
private func sha256(_ input: String) -> String {
    return input
}
#endif

class LoginWithViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var btnGoogleSignin: GIDSignInButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnFBLogin: UIButton!

    // Unhashed nonce.
    fileprivate var currentNonce: String?

    var imgs = [R.image.loginOnboarding02(), R.image.loginOnboarding03(), R.image.loginOnboarding04()]

    let provider = OAuthProvider(providerID: "twitter.com")

    var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()

        let randomIndex = Int.random(in: 0..<imgs.count)
        self.imgBackground.image = imgs[randomIndex]

        btnLogin.layer.cornerRadius = btnLogin.frame.height / 2
        btnSignup.layer.cornerRadius = btnSignup.frame.height / 2
        btnSignup.layoutSubviews()

        self.scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false

        //create the slides and add them
        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)

        let subViews = self.scrollView.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }

        let scrollWidth = self.scrollView.frame.size.width
        let scrollHeight = self.scrollView.frame.size.height

        for index in 0..<imgs.count {
            frame.origin.x = scrollWidth * CGFloat(index)
            frame.size = CGSize(width: scrollWidth, height: scrollHeight)

            let slide = UIView(frame: frame)

            //subviews
            let imageView = UIImageView.init(image: imgs[index])
            imageView.frame = CGRect(x:0, y:0, width:scrollWidth, height:scrollHeight)
            imageView.contentMode = .scaleToFill

            slide.addSubview(imageView)
            scrollView.addSubview(slide)
        }

        //set width of scrollview to accomodate all the slides
        scrollView.contentSize = CGSize(width: scrollWidth * CGFloat(imgs.count), height: scrollHeight)

        //disable vertical scroll/bounce
        self.scrollView.contentSize.height = 1.0
    }

    @IBAction func loginClicked(_ sender: Any) {
        if (isLoading) {
            return
        }
        let loginVC = R.storyboard.auth().instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
    }

    @IBAction func signupClicked(_ sender: Any) {
        if (isLoading) {
            return
        }
        let signupVC = R.storyboard.auth().instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        signupVC.modalPresentationStyle = .fullScreen
        self.present(signupVC, animated: true, completion: nil)
    }

    @IBAction func facebookClicked(_ sender: Any) {
        if (isLoading) {
            return
        }
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if (fbloginresult.grantedPermissions.contains("email")) {
                    self.getFBUserData()
                }
            }
        }
    }

    func getFBUserData(){
        if (AccessToken.current != nil) {

            isLoading = true
            SVProgressHUD.show()

            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error != nil) {
                    self.showErrorAndHideProgress(text: error!.localizedDescription)
                    return
                }

                guard let userInfo = result as? [String: Any] else {
                    self.showErrorAndHideProgress(text: "Facebook Graph Request Parsing Error!")
                    return
                }

                let email = userInfo["email"] as? String ?? ""
                if (email == "") {
                    self.showErrorAndHideProgress(text: "Facebook Graph Request Parsing Error!")
                    return
                }
                let username = userInfo["name"] as? String ?? ""
                let photoUrl = ((userInfo["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String ?? ""

                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    if let error = error {
                        self.showErrorAndHideProgress(text: error.localizedDescription)
                        return
                    }

                    // User is signed in
                    let db = Firestore.firestore()
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
                        if let existingUserDocument = snapshot.documents.first {
                            let existingUser = User(JSON: existingUserDocument.data())
                            AppManager.shared.saveCurrentUserRef(userRef: existingUserDocument.reference)

                            guard let currentUser = Auth.auth().currentUser else {
                                self.showErrorAndHideProgress(text: "User login failed!")
                                return
                            }

                            currentUser.reload { (error) in
                                if let error = error {
                                    self.showErrorAndHideProgress(text: error.localizedDescription)
                                    return
                                }

                                if (existingUser?.cardID == nil || existingUser?.cardID == "") {
                                    SVProgressHUD.dismiss()
                                    self.isLoading = false

                                    let alertController = UIAlertController(title: "Please complete your account!", message: nil, preferredStyle: .alert)
                                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                                        // cancel action
                                    }
                                    alertController.addAction(cancelAction)
                                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                                        let signupVC = R.storyboard.auth().instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
                                        signupVC.modalPresentationStyle = .fullScreen
                                        signupVC.newUserType = "facebook"
                                        signupVC.newUserEmail = email
                                        signupVC.newUserPwd = ""
                                        signupVC.newUsername = username
                                        signupVC.newFirstname = existingUser!.firstname!
                                        signupVC.newLastname = existingUser!.lastname!
                                        signupVC.newUserPhone = existingUser!.phone!
                                        signupVC.newUserAddressline = existingUser!.addressline1!
                                        signupVC.newUserCity = existingUser!.city!
                                        signupVC.newUserState = existingUser!.state!
                                        signupVC.newUserZip = existingUser!.zip!
                                        signupVC.newUserPhotoUrl = photoUrl
                                        self.present(signupVC, animated: true, completion: nil)
                                    }
                                    alertController.addAction(okAction)
                                    self.present(alertController, animated: true)
                                    return
                                }

                                SVProgressHUD.dismiss()
                                self.isLoading = false
                                if let token = Messaging.messaging().fcmToken {
                                    existingUserDocument.reference.setData(["fcmToken": token], merge: true)
                                }

                                AppManager.shared.saveCurrentUser(user: existingUser!)

                                let defaults = UserDefaults.standard
                                defaults.set("", forKey: "useremail")
                                defaults.set("", forKey: "userpwd")

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
                            }
                        } else {
                            SVProgressHUD.dismiss()
                            self.isLoading = false

                            let alertController = UIAlertController(title: "Please complete your account!", message: nil, preferredStyle: .alert)
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                                // cancel action
                            }
                            alertController.addAction(cancelAction)
                            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                                let signupVC = R.storyboard.auth().instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
                                signupVC.modalPresentationStyle = .fullScreen
                                signupVC.newUserType = "facebook"
                                signupVC.newUserEmail = email
                                signupVC.newUserPwd = ""
                                signupVC.newUsername = username
                                signupVC.newUserPhotoUrl = photoUrl
                                self.present(signupVC, animated: true, completion: nil)
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true)
                        }
                    }
                }
            })
        }
    }

    @IBAction func twitterClicked(_ sender: Any) {
        if (isLoading) {
            return
        }
        //provider must be declared in global variable
        provider.getCredentialWith(nil) { credential, error in
            if error != nil {
                self.showErrorAndHideProgress(text: error!.localizedDescription)
                return
            }

            if credential != nil {
                self.isLoading = true
                SVProgressHUD.show()

                Auth.auth().signIn(with: credential!) { authResult, error in
                    if error != nil {
                        self.showErrorAndHideProgress(text: error!.localizedDescription)
                        return
                    }

                    let username = authResult?.additionalUserInfo?.profile!["screen_name"] as? String ?? ""
                    let photoUrl = authResult?.additionalUserInfo?.profile!["profile_image_url_https"] as? String ?? ""

                    // User is signed in.
                    let db = Firestore.firestore()
                    db.collection("users").whereField("userID", isEqualTo: Auth.auth().currentUser!.uid).getDocuments { (querySnapshot, error) in
                        if let error = error {
                            self.showErrorAndHideProgress(text: error.localizedDescription)
                            return
                        }

                        guard let snapshot = querySnapshot else {
                            self.showErrorAndHideProgress(text: "There was an error signing up. Please try again.")
                            return
                        }

                        // User exists with the specified email, show error
                        if let existingUserDocument = snapshot.documents.first {
                            let existingUser = User(JSON: existingUserDocument.data())
                            AppManager.shared.saveCurrentUserRef(userRef: existingUserDocument.reference)

                            guard let currentUser = Auth.auth().currentUser else {
                                self.showErrorAndHideProgress(text: "User login failed!")
                                return
                            }

                            currentUser.reload { (error) in
                                if let error = error {
                                    self.showErrorAndHideProgress(text: error.localizedDescription)
                                    return
                                }

                                if (existingUser?.cardID == nil || existingUser?.cardID == "") {
                                    SVProgressHUD.dismiss()
                                    self.isLoading = false

                                    let alertController = UIAlertController(title: "Please complete your account!", message: nil, preferredStyle: .alert)
                                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                                        // cancel action
                                    }
                                    alertController.addAction(cancelAction)
                                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                                        let signupVC = R.storyboard.auth().instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
                                        signupVC.modalPresentationStyle = .fullScreen
                                        signupVC.newUserType = "twitter"
                                        signupVC.newUserEmail = existingUser!.email!
                                        signupVC.newUserPwd = ""
                                        signupVC.newUsername = username
                                        signupVC.newFirstname = existingUser!.firstname!
                                        signupVC.newLastname = existingUser!.lastname!
                                        signupVC.newUserPhone = existingUser!.phone!
                                        signupVC.newUserAddressline = existingUser!.addressline1!
                                        signupVC.newUserCity = existingUser!.city!
                                        signupVC.newUserState = existingUser!.state!
                                        signupVC.newUserZip = existingUser!.zip!
                                        signupVC.newUserPhotoUrl = photoUrl
                                        self.present(signupVC, animated: true, completion: nil)
                                    }
                                    alertController.addAction(okAction)
                                    self.present(alertController, animated: true)
                                    return
                                }

                                SVProgressHUD.dismiss()
                                self.isLoading = false
                                if let token = Messaging.messaging().fcmToken {
                                    existingUserDocument.reference.setData(["fcmToken": token], merge: true)
                                }

                                AppManager.shared.saveCurrentUser(user: existingUser!)

                                let defaults = UserDefaults.standard
                                defaults.set("", forKey: "useremail")
                                defaults.set("", forKey: "userpwd")

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
                            }
                        } else {
                            SVProgressHUD.dismiss()
                            self.isLoading = false

                            let alertController = UIAlertController(title: "Please complete your account!", message: nil, preferredStyle: .alert)
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                                // cancel action
                            }
                            alertController.addAction(cancelAction)
                            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                                let signupVC = R.storyboard.auth().instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
                                signupVC.modalPresentationStyle = .fullScreen
                                signupVC.newUserType = "twitter"
                                signupVC.newUserEmail = ""
                                signupVC.newUserPwd = ""
                                signupVC.newUsername = username
                                signupVC.newUserPhotoUrl = photoUrl
                                self.present(signupVC, animated: true, completion: nil)
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true)
                        }
                    }
                }
            }
        }
    }

    @IBAction func googleClicked(_ sender: Any) {
        if (isLoading) {
            return
        }
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }

    @IBAction func appleClicked(_ sender: Any) {
//        if (isLoading) {
//            return
//        }
//        if #available(iOS 13, *) {
//            startSignInWithAppleFlow()
//        } else {
//            print("User cancelled login with apple")
//        }
    }

    private func showErrorAndHideProgress(text: String) {
        SVProgressHUD.dismiss()
        isLoading = false
        self.showError(text: text)
    }

    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }

    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
        authorizationController.performRequests()
    }
}

@available(iOS 13.0, *)
extension LoginWithViewController: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                idToken: idTokenString,
                                                rawNonce: nonce)

            SVProgressHUD.show()
            isLoading = true

            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    self.showErrorAndHideProgress(text: error!.localizedDescription)
                    return
                }

                let authUser: Firebase.User = authResult!.user
                let userID = authUser.uid
                let username = "\(appleIDCredential.fullName?.givenName ?? "") \(appleIDCredential.fullName?.familyName ?? "")"
                let email = appleIDCredential.email

                let db = Firestore.firestore()
                db.collection("users").whereField("userID", isEqualTo: userID).getDocuments { (querySnapshot, error) in
                    if let error = error {
                        self.showErrorAndHideProgress(text: error.localizedDescription)
                        return
                    }

                    guard let snapshot = querySnapshot else {
                        self.showErrorAndHideProgress(text: "There was an error signing up. Please try again.")
                        return
                    }

                    // User exists with the specified email, show error
                    if let existingUserDocument = snapshot.documents.first {
                        let existingUser = User(JSON: existingUserDocument.data())
                        AppManager.shared.saveCurrentUserRef(userRef: existingUserDocument.reference)

                        guard let currentUser = Auth.auth().currentUser else {
                            self.showErrorAndHideProgress(text: "User login failed!")
                            return
                        }

                        currentUser.reload { (error) in
                            if let error = error {
                                self.showErrorAndHideProgress(text: error.localizedDescription)
                                return
                            }

                            if (existingUser?.cardID == nil || existingUser?.cardID == "") {
                                SVProgressHUD.dismiss()
                                self.isLoading = false

                                let alertController = UIAlertController(title: "Please complete your account!", message: nil, preferredStyle: .alert)
                                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                                    // cancel action
                                }
                                alertController.addAction(cancelAction)
                                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                                    let signupVC = R.storyboard.auth().instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
                                    signupVC.modalPresentationStyle = .fullScreen
                                    signupVC.newUserType = "apple"
                                    signupVC.newUserEmail = email!
                                    signupVC.newUserPwd = ""
                                    signupVC.newUsername = username
                                    signupVC.newFirstname = existingUser!.firstname!
                                    signupVC.newLastname = existingUser!.lastname!
                                    signupVC.newUserPhone = existingUser!.phone!
                                    signupVC.newUserAddressline = existingUser!.addressline1!
                                    signupVC.newUserCity = existingUser!.city!
                                    signupVC.newUserState = existingUser!.state!
                                    signupVC.newUserZip = existingUser!.zip!
                                    signupVC.newUserPhotoUrl = existingUser!.photoUrl!
                                    self.present(signupVC, animated: true, completion: nil)
                                }
                                alertController.addAction(okAction)
                                self.present(alertController, animated: true)
                                return
                            }

                            SVProgressHUD.dismiss()
                            self.isLoading = false
                            if let token = Messaging.messaging().fcmToken {
                                existingUserDocument.reference.setData(["fcmToken": token], merge: true)
                            }

                            AppManager.shared.saveCurrentUser(user: existingUser!)

                            let defaults = UserDefaults.standard
                            defaults.set("", forKey: "useremail")
                            defaults.set("", forKey: "userpwd")

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
                        }
                    } else {
                        SVProgressHUD.dismiss()
                        self.isLoading = false

                        let alertController = UIAlertController(title: "Please complete your account!", message: nil, preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                            // cancel action
                        }
                        alertController.addAction(cancelAction)
                        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                            let signupVC = R.storyboard.auth().instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
                            signupVC.modalPresentationStyle = .fullScreen
                            signupVC.newUserType = "apple"
                            signupVC.newUserEmail = email!
                            signupVC.newUserPwd = ""
                            signupVC.newUsername = username
                            signupVC.newUserPhotoUrl = ""
                            self.present(signupVC, animated: true, completion: nil)
                        }
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true)
                    }
            
                }
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}

