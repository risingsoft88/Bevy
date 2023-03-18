//
//  ContactItemTableViewCell.swift
//  Bevy
//
//  Created by macOS on 8/20/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class ContactItemTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var btnAction: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
