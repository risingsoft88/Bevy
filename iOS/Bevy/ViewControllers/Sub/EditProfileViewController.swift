//
//  EditProfileViewController.swift
//  Bevy
//
//  Created by macOS on 7/9/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class EditProfileViewController: BaseSubViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var editName: UITextField!
    @IBOutlet weak var editEmail: UITextField!
    @IBOutlet weak var editPhone: UITextField!
    @IBOutlet weak var editGender: UITextField!
    @IBOutlet weak var editBirth: UITextField!

    let imagePicker = UIImagePickerController()
    var selectedImage: UIImage? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        imagePicker.allowsEditing = true

        Utils.loadAvatar(imgAvatar)
        editName.text = AppManager.shared.currentUser?.username
        editEmail.text = AppManager.shared.currentUser?.email
        editEmail.isUserInteractionEnabled = false
        editPhone.text = AppManager.shared.currentUser?.phone
//        editGender.text = AppManager.shared.currentUser?.gender
//        editBirth.text = AppManager.shared.currentUser?.birthday

        guard let type = AppManager.shared.currentUser?.userType else { return }
        if (type == "facebook" || type == "twitter" || type == "google" || type == "apple") {
            editName.isUserInteractionEnabled = false
        }
    }

    @IBAction func changePhotoClicked(_ sender: Any) {
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
        self.showError(text: text)
    }

    @IBAction func saveClicked(_ sender: Any) {
        guard let name = editName.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let phone = editPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
//        guard let gender = editGender.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
//        guard let birth = editBirth.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        if name.isEmpty {
            showAlert("Please enter a name!")
            return
        }

        if phone.isEmpty {
            showAlert("Please enter a phone number!")
            return
        }

        guard let currentUserRef = AppManager.shared.currentUserRef else { return }
        guard let currentUser = AppManager.shared.currentUser else { return }

        currentUserRef.updateData(["username": name]);
        currentUserRef.updateData(["phone": phone]);
//        currentUserRef.updateData(["gender": gender]);
//        currentUserRef.updateData(["birthday": birth]);

        currentUser.username = name;
        currentUser.phone = phone;
//        currentUser.gender = gender;
//        currentUser.birthday = birth;

        if (selectedImage == nil) {
            AppManager.shared.saveCurrentUser(user: currentUser)
            let alertController = UIAlertController(title: "Profile updated successfully!", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
            return
        }

        let storage = Storage.storage()
        let storageRef = storage.reference()
        let data = selectedImage!.jpegData(compressionQuality: 0.8)
        guard let userID = currentUser.userID else {
            return
        }
        let avatarRef = storageRef.child("avatars/\(userID).png")

        SVProgressHUD.show()
        _ = avatarRef.putData(data!, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                self.showErrorAndHideProgress(text: "There was an error uploading profile image. Please try again.")
                return
            }
            avatarRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    self.showErrorAndHideProgress(text: "There was an error uploading profile photo. Please try again.")
                    return
                }

                SVProgressHUD.dismiss()
                currentUser.photoUrl = downloadURL.absoluteString
                currentUserRef.updateData(["photoUrl": downloadURL.absoluteString]);
                AppManager.shared.saveCurrentUser(user: currentUser)

                let alertController = UIAlertController(title: "Profile updated successfully!", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
            }
        }
    }

    //MARK:- UIImagePickerViewDelegate.
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) { [weak self] in
            guard let image = info[.editedImage] as? UIImage else { return }
            self!.selectedImage = image
            self!.imgAvatar.image = image
        }
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
}
