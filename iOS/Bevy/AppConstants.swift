//
//  AppConstants.swift
//  Bevy
//
//  Created by macOS on 6/27/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class AppConstants: NSObject {
    static let shared = AppConstants()

    var isDirtyBalance: Bool = false
    var payments : [Payment] = []
    var nLeftMenuSelectedIndex: Int = 0
    var nRightMenuSelectedIndex: Int = 0

    var leftMenuTitles = ["Wallet", "Settings"] // "Discover", "Portfolio", "Travel", "Social",
    var leftMenuViewControllers = ["WalletViewController", "SettingsViewController"] // "DiscoverViewController", "PortfolioViewController", "TravelViewController", "SocialViewController",
    var rightMenuTitles = [["Accounts", "P2P", "Savings", "Support", "", ""], // "Wallet+",
                  ["Settings R1", "Settings R2", "Settings R3", "Settings R4", "Settings R5", "Settings R6"]]
    // ["Discover R1", "Discover R2", "Discover R3", "Discover R4", "Discover R5", "Discover R6"],
    // ["Portfolio R1", "Portfolio R2", "Portfolio R3", "Portfolio R4", "Portfolio R5", "Portfolio R6"],
    // ["Flights", "Hotels", "Rideshare", "Privacy", "Help", ""],
    // ["My Profile", "Settings", "Friends", "Privacy", "Support", ""],
    var rightMenuViewControllers = [
                  ["WalletAccountsViewController", "UsersViewController", "SavingsViewController", "SupportViewController", "MainViewController", "MainViewController"], // "WalletWalletPlusViewController", WalletContactsViewController
                  ["MainViewController", "MainViewController", "MainViewController", "MainViewController", "MainViewController", "MainViewController"]]
    // ["MainViewController", "MainViewController", "MainViewController", "MainViewController", "MainViewController", "MainViewController"],
    // ["MainViewController", "MainViewController", "MainViewController", "MainViewController", "MainViewController", "MainViewController"],
    // ["TravelFlightsViewController", "TravelHotelsViewController", "FindRideViewController", "MainViewController", "MainViewController", "MainViewController"],
    // ["SocialProfileViewController", "SocialSettingsViewController", "SocialFriendsViewController", "SocialPrivacyViewController", "SupportViewController", "SocialHelpViewController"],
    var leftMenuInactiveIcons = [R.image.icon_wallet_inactive(), R.image.icon_settings_inactive()]
    // R.image.icon_discover_inactive(), R.image.icon_portfolio_inactive(), R.image.icon_travel_inactive(), R.image.icon_social_inactive(),
    var leftMenuActiveIcons = [R.image.icon_wallet_active(), R.image.icon_settings_active()]
    // R.image.icon_discover_active(), R.image.icon_portfolio_inactive(), R.image.icon_travel_active(), R.image.icon_social_active(),
    var rightMenuInactiveIcons = [

                                  [R.image.icon_discover_inactive(), R.image.icon_p2p_inactive(), R.image.icon_savings_inactive(), R.image.icon_help_inactive(), R.image.icon_wallet_inactive(), R.image.icon_crypto_inactive()], //4th - 5 menus

                                  [R.image.icon_discover_inactive(), R.image.icon_settings_inactive(), R.image.icon_driver_inactive(), R.image.icon_privacy_inactive(), R.image.icon_help_inactive(), R.image.icon_travel_inactive()]] //6th - 5 menus
    // [R.image.icon_discover_inactive(), R.image.icon_settings_inactive(), R.image.icon_portfolio_inactive(), R.image.icon_social_inactive(), R.image.icon_wallet_inactive(), R.image.icon_travel_inactive()],
    // [R.image.icon_discover_inactive(), R.image.icon_settings_inactive(), R.image.icon_portfolio_inactive(), R.image.icon_social_inactive(), R.image.icon_wallet_inactive(), R.image.icon_travel_inactive()],
    // [R.image.icon_discover_inactive(), R.image.icon_hotels_inactive(), R.image.icon_driver_inactive(), R.image.icon_privacy_inactive(), R.image.icon_help_inactive(), R.image.icon_help_inactive()], //5th - 6 menus
    // [R.image.icon_discover_inactive(), R.image.icon_settings_inactive(), R.image.icon_social_inactive(), R.image.icon_privacy_inactive(), R.image.icon_help_inactive(), R.image.icon_travel_inactive()],

//    var rightMenuActiveIcons = [R.image.icon_discover_inactive(), R.image.icon_settings_inactive(), R.image.icon_portfolio_inactive(), R.image.icon_social_inactive(), R.image.icon_wallet_active(), R.image.icon_travel_inactive()]

    var stateDictionary: [String : String] = [
    "AK" : "Alaska",
    "AL" : "Alabama",
    "AR" : "Arkansas",
    "AS" : "American Samoa",
    "AZ" : "Arizona",
    "CA" : "California",
    "CO" : "Colorado",
    "CT" : "Connecticut",
    "DC" : "District of Columbia",
    "DE" : "Delaware",
    "FL" : "Florida",
    "GA" : "Georgia",
    "GU" : "Guam",
    "HI" : "Hawaii",
    "IA" : "Iowa",
    "ID" : "Idaho",
    "IL" : "Illinois",
    "IN" : "Indiana",
    "KS" : "Kansas",
    "KY" : "Kentucky",
    "LA" : "Louisiana",
    "MA" : "Massachusetts",
    "MD" : "Maryland",
    "ME" : "Maine",
    "MI" : "Michigan",
    "MN" : "Minnesota",
    "MO" : "Missouri",
    "MS" : "Mississippi",
    "MT" : "Montana",
    "NC" : "North Carolina",
    "ND" : "North Dakota",
    "NE" : "Nebraska",
    "NH" : "New Hampshire",
    "NJ" : "New Jersey",
    "NM" : "New Mexico",
    "NV" : "Nevada",
    "NY" : "New York",
    "OH" : "Ohio",
    "OK" : "Oklahoma",
    "OR" : "Oregon",
    "PA" : "Pennsylvania",
    "PR" : "Puerto Rico",
    "RI" : "Rhode Island",
    "SC" : "South Carolina",
    "SD" : "South Dakota",
    "TN" : "Tennessee",
    "TX" : "Texas",
    "UT" : "Utah",
    "VA" : "Virginia",
    "VI" : "Virgin Islands",
    "VT" : "Vermont",
    "WA" : "Washington",
    "WI" : "Wisconsin",
    "WV" : "West Virginia",
    "WY" : "Wyoming"]

    override init() {
        super.init()
    }
}
