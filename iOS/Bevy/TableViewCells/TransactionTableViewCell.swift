//
//  TransactionTableViewCell.swift
//  Bevy
//
//  Created by macOS on 11/20/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var lblBrand: UILabel!
    @IBOutlet weak var lblLast4: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
