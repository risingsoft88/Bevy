//
//  PaymentSent.swift
//  Bevy
//
//  Created by macOS on 11/25/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import ObjectMapper

class PaymentSent: BaseObject {
    var senderID: String?
    var senderUsername: String?
    var senderEmail: String?
    var senderPhotoUrl: String?
    var receiverID: String?
    var receiverUsername: String?
    var receiverEmail: String?
    var receiverPhotoUrl: String?
    var amount: Int?
    var type: String?

    override func mapping(map: Map) {
        super.mapping(map: map)

        senderID                    <- map["senderID"]
        senderUsername              <- map["senderUsername"]
        senderEmail                 <- map["senderEmail"]
        senderPhotoUrl              <- map["senderPhotoUrl"]
        receiverID                  <- map["receiverID"]
        receiverUsername            <- map["receiverUsername"]
        receiverEmail               <- map["receiverEmail"]
        receiverPhotoUrl            <- map["receiverPhotoUrl"]
        amount                      <- map["amount"]
        type                        <- map["type"]
    }

    override func attach(_ model: BaseObject) {
        super.attach(model)
        guard let sent = model as? PaymentSent else { return }

        senderID                    = sent.senderID ?? senderID
        senderUsername              = sent.senderUsername ?? senderUsername
        senderEmail                 = sent.senderEmail ?? senderEmail
        senderPhotoUrl              = sent.senderPhotoUrl ?? senderPhotoUrl
        receiverID                  = sent.receiverID ?? receiverID
        receiverUsername            = sent.receiverUsername ?? receiverUsername
        receiverEmail               = sent.receiverEmail ?? receiverEmail
        receiverPhotoUrl            = sent.receiverPhotoUrl ?? receiverPhotoUrl
        amount                      = sent.amount ?? amount
        type                        = sent.type ?? type
    }
}
