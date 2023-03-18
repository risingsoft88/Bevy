//
//  AddContactItemTableViewCell.swift
//  Bevy
//
//  Created by macOS on 9/5/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class AddContactItemTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var imgAdd: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
