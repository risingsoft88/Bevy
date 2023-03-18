//
//  PaymentRequest.swift
//  Bevy
//
//  Created by macOS on 11/25/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import ObjectMapper

class PaymentRequest: BaseObject {
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
        guard let request = model as? PaymentRequest else { return }

        senderID                    = request.senderID ?? senderID
        senderUsername              = request.senderUsername ?? senderUsername
        senderEmail                 = request.senderEmail ?? senderEmail
        senderPhotoUrl              = request.senderPhotoUrl ?? senderPhotoUrl
        receiverID                  = request.receiverID ?? receiverID
        receiverUsername            = request.receiverUsername ?? receiverUsername
        receiverEmail               = request.receiverEmail ?? receiverEmail
        receiverPhotoUrl            = request.receiverPhotoUrl ?? receiverPhotoUrl
        amount                      = request.amount ?? amount
        type                        = request.type ?? type
    }
}
