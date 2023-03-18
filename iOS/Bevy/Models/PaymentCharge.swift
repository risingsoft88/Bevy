//
//  PaymentCharge.swift
//  Bevy
//
//  Created by macOS on 11/20/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import ObjectMapper

class PaymentCharge: BaseObject {
    var userID: String?
    var chargeSID: String?
    var transactionSID: String?
    var amount: Int?
    var net: Int?
    var fee: Int?
    var created: Int?
    var brand: String?
    var last4: String?
    var status: String?
    var type: String?

    override func mapping(map: Map) {
        super.mapping(map: map)

        userID                      <- map["userID"]
        chargeSID                   <- map["chargeSID"]
        transactionSID              <- map["transactionSID"]
        amount                      <- map["amount"]
        net                         <- map["net"]
        fee                         <- map["fee"]
        created                     <- map["created"]
        brand                       <- map["brand"]
        last4                       <- map["last4"]
        status                      <- map["status"]
        type                        <- map["type"]
    }

    override func attach(_ model: BaseObject) {
        super.attach(model)
        guard let charge = model as? PaymentCharge else { return }

        userID                      = charge.userID ?? userID
        chargeSID                   = charge.chargeSID ?? chargeSID
        transactionSID              = charge.transactionSID ?? transactionSID
        amount                      = charge.amount ?? amount
        net                         = charge.net ?? net
        fee                         = charge.fee ?? fee
        created                     = charge.created ?? created
        brand                       = charge.brand ?? brand
        last4                       = charge.last4 ?? last4
        status                      = charge.status ?? status
        type                        = charge.type ?? type
    }
}
