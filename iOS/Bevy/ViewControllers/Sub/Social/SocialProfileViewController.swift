//
//  SocialProfileViewController.swift
//  Bevy
//
//  Created by macOS on 8/15/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class SocialProfileViewController: BaseSubViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblTagname: UILabel!
    @IBOutlet weak var lblPostCount: UILabel!
    @IBOutlet weak var lblFollowingCount: UILabel!
    @IBOutlet weak var lblFollowerCount: UILabel!
    @IBOutlet weak var tblFeeds: UITableView!

    var feeds = [R.image.img_feed_photo01(), R.image.img_feed_video01(), R.image.img_feed_photo02(), R.image.img_feed_photo03(), R.image.img_feed_photo01(), R.image.img_feed_video01(), R.image.img_feed_photo02(), R.image.img_feed_photo03(), R.image.img_feed_photo01(), R.image.img_feed_video01(), R.image.img_feed_photo02(), R.image.img_feed_photo03()]

    override func viewDidLoad() {
        super.viewDidLoad()

        Utils.loadAvatar(imgAvatar)

        let name = AppManager.shared.currentUser?.username
        lblUsername.text = name
        let formattedStr = String((name?.lowercased().filter {!" \n\t\r".contains($0)})!)
        lblTagname.text = "@" + formattedStr

        tblFeeds.dataSource = self
        tblFeeds.delegate = self
        tblFeeds.register(R.nib.photoFeedTableViewCell)
    }

    @IBAction func notificationClicked(_ sender: Any) {
        let vc = R.storyboard.social().instantiateViewController(withIdentifier: "SocialNotificationViewController") as! SocialNotificationViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func dmsClicked(_ sender: Any) {
        let vc = R.storyboard.social().instantiateViewController(withIdentifier: "SocialDmsViewController") as! SocialDmsViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func newPostClicked(_ sender: Any) {
        let vc = R.storyboard.social().instantiateViewController(withIdentifier: "AddFeedViewController") as! AddFeedViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func searchFriendsClicked(_ sender: Any) {
        let vc = R.storyboard.social().instantiateViewController(withIdentifier: "SocialFriendsViewController") as! SocialFriendsViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func userProfileClicked(_ sender: Any) {
        let vc = R.storyboard.social().instantiateViewController(withIdentifier: "SocialProfileViewController") as! SocialProfileViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoFeedTableViewCell", for: indexPath) as! PhotoFeedTableViewCell
        cell.imgPhoto.image = feeds[indexPath.row]
//        let title = AppConstants.shared.rightMenuTitles[AppConstants.shared.nLeftMenuSelectedIndex][indexPath.row]
//        if (AppConstants.shared.nRightMenuSelectedIndex == indexPath.row) {
//            cell.lblTitle.textColor = UIColor.gray
//            cell.imgIcon.image = menuInactiveIcons[indexPath.row]
//        } else {
//            cell.lblTitle.textColor = UIColor.gray
//            cell.imgIcon.image = menuInactiveIcons[indexPath.row]
//        }
//        cell.lblTitle.text = title
//        cell.lblTitle.textColor = UIColor.gray
//        cell.imgIcon.image = AppConstants.shared.rightMenuInactiveIcons[AppConstants.shared.nLeftMenuSelectedIndex][indexPath.row]

        return cell
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

//        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(postAllTapped(tapGestureRecognizer:)))
//        imgPostAll.isUserInteractionEnabled = true
//        imgPostAll.addGestureRecognizer(tapGestureRecognizer)
//        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(postPhotoTapped(tapGestureRecognizer:)))
//        imgPostPhoto.isUserInteractionEnabled = true
//        imgPostPhoto.addGestureRecognizer(tapGestureRecognizer)
//        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(postVideoTapped(tapGestureRecognizer:)))
//        imgPostVideo.isUserInteractionEnabled = true
//        imgPostVideo.addGestureRecognizer(tapGestureRecognizer)
//        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(postAudioTapped(tapGestureRecognizer:)))
//        imgPostAudio.isUserInteractionEnabled = true
//        imgPostAudio.addGestureRecognizer(tapGestureRecognizer)
//
//        selectType(selectedIndex: 0)

    
//    @objc func postAllTapped(tapGestureRecognizer: UITapGestureRecognizer) {
//        selectType(selectedIndex: 0)
//    }
//    @objc func postPhotoTapped(tapGestureRecognizer: UITapGestureRecognizer) {
//        selectType(selectedIndex: 1)
//    }
//    @objc func postVideoTapped(tapGestureRecognizer: UITapGestureRecognizer) {
//        selectType(selectedIndex: 2)
//    }
//    @objc func postAudioTapped(tapGestureRecognizer: UITapGestureRecognizer) {
//        selectType(selectedIndex: 3)
//    }

//    func selectType(selectedIndex : Int) {
//        let imagWidth = imgPostContent.frame.size.width
//        if (selectedIndex == 0) {
//            imgPostAll.image = R.image.icon_post_all_active()
//            imgPostPhoto.image = R.image.icon_post_photo_inactive()
//            imgPostVideo.image = R.image.icon_post_video_inactive()
//            imgPostAudio.image = R.image.icon_post_audio_inactive()
//            imgPostContent.image = R.image.img_post_all_content()
//            imgPostContent.frame = CGRect(x:0, y:0, width:imagWidth, height:imagWidth/414*953)
//        } else if (selectedIndex == 1) {
//            imgPostAll.image = R.image.icon_post_all_inactive()
//            imgPostPhoto.image = R.image.icon_post_photo_active()
//            imgPostVideo.image = R.image.icon_post_video_inactive()
//            imgPostAudio.image = R.image.icon_post_audio_inactive()
//            imgPostContent.image = R.image.img_post_photo_content()
//            imgPostContent.frame = CGRect(x:0, y:0, width:imagWidth, height:imagWidth/414*786)
//        } else if (selectedIndex == 2) {
//            imgPostAll.image = R.image.icon_post_all_inactive()
//            imgPostPhoto.image = R.image.icon_post_photo_inactive()
//            imgPostVideo.image = R.image.icon_post_video_active()
//            imgPostAudio.image = R.image.icon_post_audio_inactive()
//            imgPostContent.image = R.image.img_post_video_content()
//            imgPostContent.frame = CGRect(x:0, y:0, width:imagWidth, height:imagWidth/414*1349)
//        } else if (selectedIndex == 3) {
//            imgPostAll.image = R.image.icon_post_all_inactive()
//            imgPostPhoto.image = R.image.icon_post_photo_inactive()
//            imgPostVideo.image = R.image.icon_post_video_inactive()
//            imgPostAudio.image = R.image.icon_post_audio_active()
//            imgPostContent.image = R.image.img_post_audio_content()
//            imgPostContent.frame = CGRect(x:0, y:0, width:imagWidth, height:imagWidth/414*1163)
//        }
//
//    }
}

