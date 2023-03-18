//
//  PhotoFeedTableViewCell.swift
//  Bevy
//
//  Created by macOS on 8/14/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class PhotoFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblPostTime: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var lblLikes: UILabel!
    @IBOutlet weak var btnDm: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        viewContainer.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
