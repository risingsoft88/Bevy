//
//  SocialFeedViewController.swift
//  Bevy
//
//  Created by macOS on 6/29/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class SocialFeedViewController: BaseSubViewController {

    @IBOutlet weak var imgSocialLive: UIImageView!
    @IBOutlet weak var imgSocialPost: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

//        let socialLiveTap = UITapGestureRecognizer(target: self, action: #selector(socialLiveClicked))
//        imgSocialLive.isUserInteractionEnabled = true
//        imgSocialLive.addGestureRecognizer(socialLiveTap)
        let socialPostTap = UITapGestureRecognizer(target: self, action: #selector(socialPostClicked))
        imgSocialPost.isUserInteractionEnabled = true
        imgSocialPost.addGestureRecognizer(socialPostTap)
    }

    @objc func socialLiveClicked() {
        let viewController = R.storyboard.social().instantiateViewController(withIdentifier: "FeedLivestreamViewController") as! FeedLivestreamViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }

    @objc func socialPostClicked() {
        let viewController = R.storyboard.social().instantiateViewController(withIdentifier: "SocialCommentsViewController") as! SocialCommentsViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
}
