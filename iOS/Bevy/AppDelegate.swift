//
//  AppDelegate.swift
//  Bevy
//
//  Created by macOS on 6/18/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn

import Firebase
import FirebaseFirestore
import FirebaseMessaging
import UserNotifications
import FirebaseInstanceID

import Stripe

import SVProgressHUD

import GooglePlaces

import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, GIDSignInDelegate, MessagingDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        FirebaseApp.configure()

        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()

        Messaging.messaging().delegate = self

//        Messaging.messaging().token { token, error in
//          if let error = error {
//            print("Error fetching FCM registration token: \(error)")
//          } else if let token = token {
//            print("FCM registration token: \(token)")
//            self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
//          }
//        }

        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self

        IQKeyboardManager.shared.enable = true

//        Stripe.setDefaultPublishableKey("pk_test_wnRxX3ShFy6jDraeTNFjXfV4") //secret key : sk_test_DarDPNwErYCGZym68iTRTTLD
        Stripe.setDefaultPublishableKey("pk_live_6e9JKARc02RUpHCuxuD8iFow") //secret key : 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

        GMSPlacesClient.provideAPIKey("AIzaSyDsTupX6E0G9pHKjJjGYIFibu4dg68oJ1o")

        Thread.sleep(forTimeInterval: 3.0)
        
        let defaults = UserDefaults.standard
        let strRemember = defaults.string(forKey: "remember") ?? ""
        let useremail = defaults.string(forKey: "useremail") ?? ""
        let userpwd = defaults.string(forKey: "userpwd") ?? ""
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let initialViewController = R.storyboard.auth().instantiateViewController(withIdentifier: (strRemember == "remember" && useremail != "" && userpwd != "") ? "LoginViewController" : "LoginWithViewController")

        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
        ApplicationDelegate.shared.application(
            application,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
//        let googleAuthentication = GIDSignIn.sharedInstance().handle(url)
//        if TwitterLoginKit.shared.application(application, open: url, options: options) {
//            return true
//        }
//        return googleAuthentication
        return GIDSignIn.sharedInstance().handle(url)
    }

//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        let googleAuthentication = GIDSignIn.sharedInstance().handle(url)
//        let twitterAuth = TwitterLoginKit.shared.application(app, open: url, options: options)
//        return googleAuthentication || twitterAuth
//    }

    // The callback to handle data message received via FCM for devices running iOS 10 or above.
//    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
//        print(remoteMessage.appData)
//    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")

        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }

    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    //Google sign in
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                        accessToken: authentication.accessToken)

        SVProgressHUD.show()

        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                SVProgressHUD.dismiss()
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(action)
                GIDSignIn.sharedInstance()?.presentingViewController.present(alert, animated: true, completion: nil)
                return
            }

            // User is signed in
            let authUser: Firebase.User = authResult!.user
            let userID = authUser.uid
            let username = user.profile.name
            let email = user.profile.email
            let photoUrl = user.profile.imageURL(withDimension: 400)?.absoluteString ?? ""

            let db = Firestore.firestore()
            db.collection("users").whereField("userID", isEqualTo: userID).getDocuments { (querySnapshot, error) in
                if let error = error {
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alert.addAction(action)
                    GIDSignIn.sharedInstance()?.presentingViewController.present(alert, animated: true, completion: nil)
                    return
                }

                guard let snapshot = querySnapshot else {
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Error", message: "There was an error signing up. Please try again.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alert.addAction(action)
                    GIDSignIn.sharedInstance()?.presentingViewController.present(alert, animated: true, completion: nil)
                    return
                }

                // User exists with the specified email, show error
                if let existingUserDocument = snapshot.documents.first {
                    let existingUser = User(JSON: existingUserDocument.data())
                    AppManager.shared.saveCurrentUserRef(userRef: existingUserDocument.reference)

                    guard let currentUser = Auth.auth().currentUser else {
                        SVProgressHUD.dismiss()
                        let alert = UIAlertController(title: "Error", message: "User login failed!", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        alert.addAction(action)
                        GIDSignIn.sharedInstance()?.presentingViewController.present(alert, animated: true, completion: nil)
                        return
                    }

                    currentUser.reload { (error) in
                        if let error = error {
                            SVProgressHUD.dismiss()
                            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                            alert.addAction(action)
                            GIDSignIn.sharedInstance()?.presentingViewController.present(alert, animated: true, completion: nil)
                            return
                        }

                        if (existingUser?.cardID == nil || existingUser?.cardID == "") {
                            SVProgressHUD.dismiss()
                            
                            let alertController = UIAlertController(title: "Please complete your account!", message: nil, preferredStyle: .alert)
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                                // cancel action
                            }
                            alertController.addAction(cancelAction)
                            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                                let signupVC = R.storyboard.auth().instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
                                signupVC.modalPresentationStyle = .fullScreen
                                signupVC.newUserType = "google"
                                signupVC.newUserEmail = email!
                                signupVC.newUserPwd = ""
                                signupVC.newUsername = username!
                                signupVC.newFirstname = existingUser!.firstname!
                                signupVC.newLastname = existingUser!.lastname!
                                signupVC.newUserPhone = existingUser!.phone!
                                signupVC.newUserAddressline = existingUser!.addressline1!
                                signupVC.newUserCity = existingUser!.city!
                                signupVC.newUserState = existingUser!.state!
                                signupVC.newUserZip = existingUser!.zip!
                                signupVC.newUserPhotoUrl = photoUrl
                                GIDSignIn.sharedInstance()?.presentingViewController.present(signupVC, animated: true, completion: nil)
                            }
                            alertController.addAction(okAction)
                            GIDSignIn.sharedInstance()?.presentingViewController.present(alertController, animated: true)
                            return
                        }

                        SVProgressHUD.dismiss()
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
                            GIDSignIn.sharedInstance()?.presentingViewController.present(vc, animated: true, completion: nil)
                        } else {
                            let vc = R.storyboard.auth().instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
                            vc.modalPresentationStyle = .fullScreen
                            GIDSignIn.sharedInstance()?.presentingViewController.present(vc, animated: true, completion: nil)
                        }
                    }
                } else {
                    SVProgressHUD.dismiss()

                    let alertController = UIAlertController(title: "Please complete your account!", message: nil, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                        // cancel action
                    }
                    alertController.addAction(cancelAction)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        let signupVC = R.storyboard.auth().instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
                        signupVC.modalPresentationStyle = .fullScreen
                        signupVC.newUserType = "google"
                        signupVC.newUserEmail = email!
                        signupVC.newUserPwd = ""
                        signupVC.newUsername = username!
                        signupVC.newUserPhotoUrl = photoUrl
                        GIDSignIn.sharedInstance()?.presentingViewController.present(signupVC, animated: true, completion: nil)
                    }
                    alertController.addAction(okAction)
                    GIDSignIn.sharedInstance()?.presentingViewController.present(alertController, animated: true)
                }
            }
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        print("Google user has disconnected")
    }

}

