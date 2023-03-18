//
//  AddFeedViewController.swift
//  Bevy
//
//  Created by macOS on 8/15/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class AddFeedViewController: BaseSubViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var viewTextWrapper: UIView!
    @IBOutlet weak var viewMediaWrapper: UIView!
    @IBOutlet weak var viewOthersWrapper: UIView!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var editMessage: UITextView!
    @IBOutlet weak var editTagFriends: UITextField!
    @IBOutlet weak var editLocation: UITextField!

    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewTextWrapper.layer.cornerRadius = 10
        viewMediaWrapper.layer.cornerRadius = 10
        viewOthersWrapper.layer.cornerRadius = 10
        btnShare.layer.cornerRadius = 10

        Utils.loadAvatar(imgAvatar)

        let contentTap = UITapGestureRecognizer(target: self, action: #selector(addMediaClicked))
        viewMediaWrapper.isUserInteractionEnabled = true
        viewMediaWrapper.addGestureRecognizer(contentTap)

        editMessage.delegate = self
        editMessage.text = "What's on your mind?"
        editMessage.textColor = UIColor.lightGray
    }

    @objc func addMediaClicked() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        self.present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func shareClicked(_ sender: Any) {
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What's on your mind?"
            textView.textColor = UIColor.lightGray
        }
    }

    //MARK:- UIImagePickerViewDelegate.
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        self.dismiss(animated: true) { [weak self] in
//            guard let image = info[.editedImage] as? UIImage else { return }
//            self!.selectedImage = image
//            self!.imgAvatar.image = image
            
//            let videoURL = info[UIImagePickerController.InfoKey.mediaURL.rawValue]as? NSURL
//            print(videoURL!)
//            do {
//                let asset = AVURLAsset(url: videoURL as! URL , options: nil)
//                let imgGenerator = AVAssetImageGenerator(asset: asset)
//                imgGenerator.appliesPreferredTrackTransform = true
//                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
//                let thumbnail = UIImage(cgImage: cgImage)
//                imgView.image = thumbnail
//            } catch let error {
//                print("*** Error generating thumbnail: \(error.localizedDescription)")
//            }
            
//        }

        // To handle image
        if let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {

        } else {
            print("Something went wrong in image")
        }
        // To handle video
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL.rawValue] as? NSURL{
            print("videourl: ", videoUrl)
            //trying compression of video
            let data = NSData(contentsOf: videoUrl as URL)!
            print("File size before compression: \(Double(data.length / 1048576)) mb")
        } else {
            print("Something went wrong in video")
        }
        dismiss(animated: true, completion: nil)
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
}
