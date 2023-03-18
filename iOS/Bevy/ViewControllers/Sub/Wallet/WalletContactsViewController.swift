//
//  WalletContactsViewController.swift
//  Bevy
//
//  Created by macOS on 8/5/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

class WalletContactsViewController: BaseSubViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, WalletSendMoneyViewControllerDelegate {

    @IBOutlet weak var scrollRecents: UIScrollView!
    @IBOutlet weak var tblContacts: UITableView!
    @IBOutlet weak var imgContactPlus: UIImageView!
    @IBOutlet weak var lblContactPlus: UILabel!

    var recents = [R.image.img_user_photo01(), R.image.img_user_photo02(), R.image.img_user_photo03(), R.image.img_user_photo04(), R.image.img_user_photo05(), R.image.img_user_photo06(), R.image.img_user_photo01(), R.image.img_user_photo02(), R.image.img_user_photo03()]
    var contacts = [R.image.img_user_photo01(), R.image.img_user_photo02(), R.image.img_user_photo03(), R.image.img_user_photo04(), R.image.img_user_photo05(), R.image.img_user_photo06(), R.image.img_user_photo01(), R.image.img_user_photo02(), R.image.img_user_photo03(), R.image.img_user_photo04(), R.image.img_user_photo05(), R.image.img_user_photo06()]

    var scrollWidth: CGFloat! = 0.0
    var scrollHeight: CGFloat! = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addContactTapped(tapGestureRecognizer:)))
        imgContactPlus.isUserInteractionEnabled = true
        imgContactPlus.addGestureRecognizer(tapGestureRecognizer)
        lblContactPlus.isUserInteractionEnabled = true
        lblContactPlus.addGestureRecognizer(tapGestureRecognizer)

        tblContacts.dataSource = self
        tblContacts.delegate = self
        tblContacts.register(R.nib.contactItemTableViewCell)

        self.view.layoutIfNeeded()
        //to call viewDidLayoutSubviews() and get dynamic width and height of scrollview

        self.scrollRecents.delegate = self
        scrollRecents.isPagingEnabled = false
        scrollRecents.showsHorizontalScrollIndicator = false
        scrollRecents.showsVerticalScrollIndicator = false

        let subViews = self.scrollRecents.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }

        //create the slides and add them
        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)

        for index in 0..<recents.count {
            frame.origin.x = (scrollHeight+16) * CGFloat(index)
            frame.size = CGSize(width: scrollHeight, height: scrollHeight)

            let slide = UIView(frame: frame)

            //subviews
            let imageView = UIImageView.init(image: recents[index])
            imageView.frame = CGRect(x:8, y:0, width:scrollHeight, height:scrollHeight)
            imageView.contentMode = .scaleToFill

            let contactTap = UITapGestureRecognizer(target: self, action: #selector(contactClicked))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(contactTap)

            slide.addSubview(imageView)
            scrollRecents.addSubview(slide)
        }

        //set width of scrollview to accomodate all the slides
        scrollRecents.contentSize = CGSize(width: (scrollHeight+16) * CGFloat(recents.count), height: scrollHeight)

        //disable vertical scroll/bounce
        self.scrollRecents.contentSize.height = 1.0
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        scrollWidth = scrollRecents.frame.size.width
        scrollHeight = scrollRecents.frame.size.height
    }

    @objc func contactClicked(tapGestureRecognizer: UITapGestureRecognizer) {
        let vc = R.storyboard.wallet().instantiateViewController(withIdentifier: "WalletSendMoneyViewController") as! WalletSendMoneyViewController
//        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    @objc func addContactTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let vc = R.storyboard.wallet().instantiateViewController(withIdentifier: "ContactAddViewController") as! ContactAddViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    func gotoDashboard() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactItemTableViewCell", for: indexPath) as! ContactItemTableViewCell
        cell.imgAvatar.image = contacts[indexPath.row]
//        let title = AppConstants.shared.rightMenuTitles[AppConstants.shared.nLeftMenuSelectedIndex][indexPath.row]
//        if (AppConstants.shared.nRightMenuSelectedIndex == indexPath.row) {
//            cell.lblTitle.textColor = UIColor.gray
//            cell.imgIcon.image = menuInactiveIcons[indexPath.row]
//        } else {
//            cell.lblTitle.textColor = UIColor.gray
//            cell.imgIcon.image = menuInactiveIcons[indexPath.row]
//        }
//        cell.lblTitle.text = title
//        cell.lblTitle.textColor = UIColor.gray
//        cell.imgIcon.image = AppConstants.shared.rightMenuInactiveIcons[AppConstants.shared.nLeftMenuSelectedIndex][indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//
//        AppConstants.shared.nRightMenuSelectedIndex = indexPath.row
//
//        let strController = AppConstants.shared.rightMenuViewControllers[AppConstants.shared.nLeftMenuSelectedIndex][indexPath.row]
//        var storyboard : UIStoryboard
//        if (AppConstants.shared.nLeftMenuSelectedIndex == 0) {
//            storyboard = R.storyboard.social()
//        } else if (AppConstants.shared.nLeftMenuSelectedIndex == 1) {
//            storyboard = R.storyboard.wallet()
//        } else {
//            storyboard = R.storyboard.sub()
//        }
//        if (strController == "MainViewController" || strController == "SupportViewController") {
//            storyboard = R.storyboard.sub()
//        }
//        let viewController = storyboard.instantiateViewController(withIdentifier: strController)
//        presentViewController(viewController: viewController)
    }
}
