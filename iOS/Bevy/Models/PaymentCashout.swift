//
//  PaymentCashout.swift
//  Bevy
//
//  Created by macOS on 12/14/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import ObjectMapper

class PaymentCashout: BaseObject {
    var userID: String?
    var amount: Int?
    var type: String?

    override func mapping(map: Map) {
        super.mapping(map: map)

        userID                      <- map["userID"]
        amount                      <- map["amount"]
        type                        <- map["type"]
    }

    override func attach(_ model: BaseObject) {
        super.attach(model)
        guard let cashout = model as? PaymentCashout else { return }

        userID                      = cashout.userID ?? userID
        amount                      = cashout.amount ?? amount
        type                        = cashout.type ?? type
    }
}
