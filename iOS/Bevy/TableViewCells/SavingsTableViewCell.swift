//
//  SavingsTableViewCell.swift
//  Bevy
//
//  Created by macOS on 9/3/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class SavingsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAmount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
