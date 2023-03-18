//
//  LeftMenuTableViewCell.swift
//  Bevy
//
//  Created by macOS on 6/27/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class LeftMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setView(title: String, icon: UIImage) {
//        lblTitle.text = title
//        imgIcon.image = icon
    }

}
