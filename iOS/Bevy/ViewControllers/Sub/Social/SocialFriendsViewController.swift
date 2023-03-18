//
//  SocialFriendsViewController.swift
//  Bevy
//
//  Created by macOS on 8/4/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class SocialFriendsViewController: BaseSubViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var viewSearchWrapper: UIView!
    @IBOutlet weak var scrollConnects: UIScrollView!
    @IBOutlet weak var tblFriends: UITableView!
    @IBOutlet weak var editSearch: UITextField!

    var connects = [R.image.img_facebook_connect(), R.image.img_twitter_connect(), R.image.img_instagram_connect()]
    var friends = [R.image.img_user_photo01(), R.image.img_user_photo02(), R.image.img_user_photo03(), R.image.img_user_photo04(), R.image.img_user_photo05(), R.image.img_user_photo06(), R.image.img_user_photo01(), R.image.img_user_photo02(), R.image.img_user_photo03(), R.image.img_user_photo04(), R.image.img_user_photo05(), R.image.img_user_photo06()]

    var scrollWidth: CGFloat! = 0.0
    var scrollHeight: CGFloat! = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        viewSearchWrapper.addBottomBorderWithColor(color: UIColor.lightGray, width: 1)

        tblFriends.dataSource = self
        tblFriends.delegate = self
        tblFriends.register(R.nib.followFriendTableViewCell)

        self.view.layoutIfNeeded()
        //to call viewDidLayoutSubviews() and get dynamic width and height of scrollview

        self.scrollConnects.delegate = self
        scrollConnects.isPagingEnabled = false
        scrollConnects.showsHorizontalScrollIndicator = false
        scrollConnects.showsVerticalScrollIndicator = false

        let subViews = self.scrollConnects.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }

        //create the slides and add them
        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)

        for index in 0..<connects.count {
            frame.origin.x = (158+16) * CGFloat(index)
            frame.size = CGSize(width: 158, height: scrollHeight)

            let slide = UIView(frame: frame)

            //subviews
            let imageView = UIImageView.init(image: connects[index])
            imageView.frame = CGRect(x:8, y:0, width:158, height:scrollHeight)
            imageView.contentMode = .scaleAspectFit
//            imageView.center = CGPoint(x:scrollWidth/2,y: scrollHeight/2 - 50)

            let contentTap = UITapGestureRecognizer(target: self, action: #selector(contentClicked))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(contentTap)

            slide.addSubview(imageView)
            scrollConnects.addSubview(slide)
        }

        //set width of scrollview to accomodate all the slides
        scrollConnects.contentSize = CGSize(width: (158+16) * CGFloat(connects.count), height: scrollHeight)

        //disable vertical scroll/bounce
        self.scrollConnects.contentSize.height = 1.0
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        scrollWidth = scrollConnects.frame.size.width
        scrollHeight = scrollConnects.frame.size.height
    }

    @objc func contentClicked() {
        let viewController = R.storyboard.social().instantiateViewController(withIdentifier: "InviteFriendsViewController") as! InviteFriendsViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }

    @IBAction func followAllClicked(_ sender: Any) {
    }

    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowFriendTableViewCell", for: indexPath) as! FollowFriendTableViewCell
        cell.imgAvatar.image = friends[indexPath.row]
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
//    }
}

