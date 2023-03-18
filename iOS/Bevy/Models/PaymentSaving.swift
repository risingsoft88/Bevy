//
//  PaymentSaving.swift
//  Bevy
//
//  Created by macOS on 12/2/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import ObjectMapper

class PaymentSaving: BaseObject {
    var userID: String?
    var time: Int?
    var amount: Int?
    var rounded: Int?
    var type: String?

    override func mapping(map: Map) {
        super.mapping(map: map)

        userID                      <- map["userID"]
        time                        <- map["time"]
        amount                      <- map["amount"]
        rounded                     <- map["rounded"]
        type                        <- map["type"]
    }

    override func attach(_ model: BaseObject) {
        super.attach(model)
        guard let saving = model as? PaymentSaving else { return }

        userID                      = saving.userID ?? userID
        time                        = saving.time ?? time
        amount                      = saving.amount ?? amount
        rounded                     = saving.rounded ?? rounded
        type                        = saving.type ?? type
    }
}
