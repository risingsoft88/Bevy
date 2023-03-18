//
//  SocialViewController.swift
//  Bevy
//
//  Created by macOS on 6/27/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class SocialViewController: BaseMenuViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var scrollUsers: UIScrollView!
    @IBOutlet weak var tblFeeds: UITableView!

    var scrollWidth: CGFloat! = 0.0
    var scrollHeight: CGFloat! = 0.0

    var imgs = [R.image.img_user_avatar01(), R.image.img_user_avatar02(), R.image.img_user_avatar03(), R.image.img_user_avatar04(), R.image.img_user_avatar05(), R.image.img_user_avatar06(), R.image.img_user_avatar01(), R.image.img_user_avatar02(), R.image.img_user_avatar03(), R.image.img_user_avatar04(), R.image.img_user_avatar05(), R.image.img_user_avatar06()]

    var feeds = [R.image.img_feed_photo01(), R.image.img_feed_video01(), R.image.img_feed_photo02(), R.image.img_feed_photo03(), R.image.img_feed_photo01(), R.image.img_feed_video01(), R.image.img_feed_photo02(), R.image.img_feed_photo03(),R.image.img_feed_photo01(), R.image.img_feed_video01(), R.image.img_feed_photo02(), R.image.img_feed_photo03()]

    override func viewDidLoad() {
        super.viewDidLoad()

        tblFeeds.dataSource = self
        tblFeeds.delegate = self
        tblFeeds.register(R.nib.photoFeedTableViewCell)

        self.view.layoutIfNeeded()
        //to call viewDidLayoutSubviews() and get dynamic width and height of scrollview

        self.scrollUsers.delegate = self
        scrollUsers.isPagingEnabled = false
        scrollUsers.showsHorizontalScrollIndicator = false
        scrollUsers.showsVerticalScrollIndicator = false

        let subViews = self.scrollUsers.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }

        //create the slides and add them
        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)

        for index in 0..<imgs.count {
            frame.origin.x = (scrollHeight+16) * CGFloat(index)
            frame.size = CGSize(width: scrollHeight, height: scrollHeight)

            let slide = UIView(frame: frame)

            //subviews
            let imageView = UIImageView.init(image: imgs[index])
            imageView.frame = CGRect(x:8, y:0, width:scrollHeight, height:scrollHeight)
            imageView.contentMode = .scaleToFill
//            imageView.center = CGPoint(x:scrollWidth/2,y: scrollHeight/2 - 50)

            slide.addSubview(imageView)
            scrollUsers.addSubview(slide)
        }

        //set width of scrollview to accomodate all the slides
        scrollUsers.contentSize = CGSize(width: (scrollHeight+16) * CGFloat(imgs.count), height: scrollHeight)

        //disable vertical scroll/bounce
        self.scrollUsers.contentSize.height = 1.0
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        scrollWidth = scrollUsers.frame.size.width
        scrollHeight = scrollUsers.frame.size.height
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
}

