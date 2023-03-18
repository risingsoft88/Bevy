//
//  User.swift
//  Bevy
//
//  Created by macOS on 7/7/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import ObjectMapper

class User: BaseObject {
    // User property
    var userID: String?
    var firstname: String?
    var lastname: String?
    var username: String?
    var email: String?
    var password: String?
    var photoUrl: String?
    var userType: String?
    var phone: String?
    var gender: String?
    var birthday: String?
    var addressline1: String?
    var addressline2: String?
    var city: String?
    var state: String?
    var zip: String?
    var legalname: String?
    var birthdayopti: String?
    var emailopti: String?
    var fcmToken: String?
    var savedAmount: Int?
    var cardID: String?
    var cardNumber: String?
    var availableAmount: Int?

    override func mapping(map: Map) {
        super.mapping(map: map)

        userID                      <- map["userID"]
        firstname                   <- map["firstname"]
        lastname                    <- map["lastname"]
        username                    <- map["username"]
        email                       <- map["email"]
        password                    <- map["password"]
        photoUrl                    <- map["photoUrl"]
        userType                    <- map["userType"]
        phone                       <- map["phone"]
        gender                      <- map["gender"]
        birthday                    <- map["birthday"]
        addressline1                <- map["addressline1"]
        addressline2                <- map["addressline2"]
        city                        <- map["city"]
        state                       <- map["state"]
        zip                         <- map["zip"]
        legalname                   <- map["legalname"]
        birthdayopti                <- map["birthdayopti"]
        emailopti                   <- map["emailopti"]
        fcmToken                    <- map["fcmToken"]
        savedAmount                 <- map["savedAmount"]
        cardID                      <- map["cardID"]
        cardNumber                  <- map["cardNumber"]
        availableAmount             <- map["availableAmount"]
    }

    override func attach(_ model: BaseObject) {
        super.attach(model)
        guard let user = model as? User else { return }

        userID              = user.userID ?? userID
        firstname           = user.firstname ?? firstname
        lastname            = user.lastname ?? lastname
        username            = user.username ?? username
        email               = user.email ?? email
        password            = user.password ?? password
        photoUrl            = user.photoUrl ?? photoUrl
        userType            = user.userType ?? userType
        phone               = user.phone ?? phone
        gender              = user.gender ?? gender
        birthday            = user.birthday ?? birthday
        addressline1        = user.addressline1 ?? addressline1
        addressline2        = user.addressline2 ?? addressline2
        city                = user.city ?? city
        state               = user.state ?? state
        zip                 = user.zip ?? zip
        legalname           = user.legalname ?? legalname
        birthdayopti        = user.birthdayopti ?? birthdayopti
        emailopti           = user.emailopti ?? emailopti
        fcmToken            = user.fcmToken ?? fcmToken
        savedAmount         = user.savedAmount ?? savedAmount
        cardID              = user.cardID ?? cardID
        cardNumber          = user.cardNumber ?? cardNumber
        availableAmount     = user.availableAmount ?? availableAmount
    }
}
