//
//  WalletAccountsViewController.swift
//  Bevy
//
//  Created by macOS on 7/1/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit
import Stripe
import CreditCardForm
import Firebase
import FirebaseFirestore
import SVProgressHUD

protocol WalletAccountsViewControllerDelegate : NSObjectProtocol{
    func selectCardWith(cardInfo: Card)
}

class WalletAccountsViewController: BaseSubViewController, UIScrollViewDelegate, AddCardViewControllerDelegate, STPPaymentCardTextFieldDelegate {

    var isChoose = false

    weak var delegate : WalletAccountsViewControllerDelegate?

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewSeperator: UIView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var stackAddCard: UIStackView!
    @IBOutlet weak var stackAddBank: UIStackView!
    @IBOutlet weak var viewBevyCard: UIView!
    @IBOutlet weak var viewCardInfo: UIView!

    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var lblUsername: UILabel!

    var scrollWidth: CGFloat! = 0.0
    var scrollHeight: CGFloat! = 0.0

    //data for the slides
    var cards: [Card] = []
    var cardRefs: [DocumentReference] = []
    var cardForms: [CreditCardFormView] = []

    var bEditing = false

    //https://stripe.com/docs/testing

    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false

        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addCardTapped(tapGestureRecognizer:)))
        stackAddCard.isUserInteractionEnabled = true
        stackAddCard.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addBankTapped(tapGestureRecognizer:)))
        stackAddBank.isUserInteractionEnabled = true
        stackAddBank.addGestureRecognizer(tapGestureRecognizer)

        viewCardInfo.layer.cornerRadius = 10

        let amount: Double = Double(AppManager.shared.currentUser!.availableAmount!) / Double(100.0)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.groupingSeparator = ","
        let formatted = formatter.string(from: NSNumber(value: amount >= 0 ? amount : amount * (-1) ))
        lblAmount.text = "$ " + formatted!
        lblUsername.text = AppManager.shared.currentUser!.firstname! + " " + AppManager.shared.currentUser!.lastname!
        lblCardNumber.text = "**** **** **** " + AppManager.shared.currentUser!.cardNumber!

        btnEdit.isHidden = true
        showEditButton()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if (self.isBeingPresented || self.isMovingToParent) {
            SVProgressHUD.show()

            let db = Firestore.firestore()
            db.collection("cards").whereField("userID", isEqualTo: AppManager.shared.currentUser!.userID!).getDocuments { (querySnapshot, error) in
                if let error = error {
                    self.showErrorAndHideProgress(text: error.localizedDescription)
                    return
                }

                SVProgressHUD.dismiss()

                for document in querySnapshot!.documents {
                    let cardInfo = Card(JSON: document.data())
                    self.cardRefs.append(document.reference)
                    self.cards.append(cardInfo!)
                }

                self.loadCards()
            }
        }
    }

    override func viewDidLayoutSubviews() {
        scrollWidth = scrollView.frame.size.width
        scrollHeight = scrollView.frame.size.height

        for index in 0..<cardForms.count {
            cardForms[index].paymentCardTextFieldDidChange(cardNumber: cards[index].cardNumber, expirationYear: cards[index].expirationYear, expirationMonth: cards[index].expirationMonth, cvc: cards[index].cvc)
            cardForms[index].cardHolderString = cards[index].cardHolder!
        }
    }

    @objc func addCardTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let vc = R.storyboard.wallet().instantiateViewController(withIdentifier: "AddCardViewController") as! AddCardViewController
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        vc.isAdd = true
        self.present(vc, animated: true, completion: nil)
    }

    @objc func addBankTapped(tapGestureRecognizer: UITapGestureRecognizer) {
    }

    private func showEditButton() {
        btnEdit.setTitle(bEditing ? "Done" : "Edit", for: .normal)
    }

    private func showErrorAndHideProgress(text: String) {
        SVProgressHUD.dismiss()
        self.showError(text: text)
    }

    private func loadCards() {
        self.view.layoutIfNeeded()

        let subViews = self.scrollView.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }

        cardForms.removeAll()
        //create the slides and add them
        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)

        for index in 0..<cards.count {
            frame.origin.x = scrollWidth * CGFloat(index)
            frame.size = CGSize(width: scrollWidth, height: scrollHeight)

            let slide = UIView(frame: frame)

            //subviews
            let creditCardView = CreditCardFormView.init()
//            creditCardView.cardHolderExpireDateColor = UIColor.black
//            creditCardView.cardHolderExpireDateTextColor = UIColor.black
//            creditCardView.backLineColor = UIColor.red
//            creditCardView.cardGradientColors[Brands.Visa.rawValue] = [UIColor.white, UIColor.black]
//            NONE, Visa, UnionPay, MasterCard, Amex, JCB, DEFAULT, Discover
//            creditCardView.defaultCardColor = UIColor.white
//            creditCardView.cardGradientColors = [Brands.NONE.rawValue: [UIColor.white, UIColor.black]]
//            creditCardView.cardGradientColors = [Brands.Visa.rawValue: [UIColor.white, UIColor.black]]
//            creditCardView.cardGradientColors = [Brands.UnionPay.rawValue: [UIColor.white, UIColor.black]]
//            creditCardView.cardGradientColors = [Brands.MasterCard.rawValue: [UIColor.white, UIColor.black]]
//            creditCardView.cardGradientColors = [Brands.Amex.rawValue: [UIColor.white, UIColor.black]]
//            creditCardView.cardGradientColors = [Brands.JCB.rawValue: [UIColor.white, UIColor.black]]
//            creditCardView.cardGradientColors = [Brands.DEFAULT.rawValue: [UIColor.white, UIColor.black]]
//            creditCardView.cardGradientColors = [Brands.Discover.rawValue: [UIColor.white, UIColor.black]]
            creditCardView.frame = CGRect(x:(scrollWidth-300)/2, y:(scrollHeight-200)/2, width:300, height:200)
            cardForms.append(creditCardView)

            let imageDelete = UIImageView.init(image: R.image.icon_closebutton())
            imageDelete.frame = CGRect(x:(scrollWidth-300)/2 + 300 - 15, y:(scrollHeight-200)/2 - 15, width:30, height:30)
            imageDelete.contentMode = .scaleToFill
            imageDelete.isHidden = true //!bEditing

            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cardTapped(tapGestureRecognizer:)))
            creditCardView.isUserInteractionEnabled = true
            creditCardView.addGestureRecognizer(tapGestureRecognizer)

//            tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cardDeleteTapped(tapGestureRecognizer:)))
//            imageDelete.tag = index
//            imageDelete.isUserInteractionEnabled = true
//            imageDelete.addGestureRecognizer(tapGestureRecognizer)

            slide.addSubview(creditCardView)
            slide.addSubview(imageDelete)
            scrollView.addSubview(slide)
        }

        //set width of scrollview to accomodate all the slides
        scrollView.contentSize = CGSize(width: scrollWidth * CGFloat(cards.count), height: scrollHeight)

        //disable vertical scroll/bounce
        self.scrollView.contentSize.height = 1.0
    }

    @objc func cardTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let page = (scrollView.contentOffset.x)/scrollWidth

        if (isChoose) {
            if let delegate = self.delegate {
                delegate.selectCardWith(cardInfo: self.cards[Int(page)])
                self.dismiss(animated: true, completion: nil)
            }
            return
        }

        let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        let detailAction = UIAlertAction(title: "Card Details", style: .default) {
//            UIAlertAction in
//            let vc = R.storyboard.wallet().instantiateViewController(withIdentifier: "CardInfoViewController") as! CardInfoViewController
//            vc.cardInfo = self.cards[Int(page)]
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: true, completion: nil)
//        }
        let editAction = UIAlertAction(title: "Edit Card", style: .default) {
            UIAlertAction in
            let vc = R.storyboard.wallet().instantiateViewController(withIdentifier: "AddCardViewController") as! AddCardViewController
            vc.modalPresentationStyle = .fullScreen
            vc.delegate = self
            vc.isAdd = false
            vc.cardIndex = Int(page)
            vc.cardInfo = self.cards[Int(page)]
            vc.cardInfoRef = self.cardRefs[Int(page)]
            self.present(vc, animated: true, completion: nil)
        }
        let deleteAction = UIAlertAction(title: "Delete Card", style: .destructive) {
            UIAlertAction in
            SVProgressHUD.show()
            self.cardRefs[Int(page)].delete { error in
                if let error = error {
                    self.showErrorAndHideProgress(text: error.localizedDescription)
                    return
                }

                SVProgressHUD.dismiss()

                self.cards.remove(at: Int(page))
                self.cardRefs.remove(at: Int(page))

                self.loadCards()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            UIAlertAction in
        }

        // Add the actions
//        alert.addAction(detailAction)
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    @objc func cardDeleteTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let index = tapGestureRecognizer.view!.tag
        let confirmAlert = UIAlertController(title: "Are you sure want to delete?", message: "", preferredStyle: UIAlertController.Style.alert)
        confirmAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            SVProgressHUD.show()
            self.cardRefs[index].delete { error in
                if let error = error {
                    self.showErrorAndHideProgress(text: error.localizedDescription)
                    return
                }

                SVProgressHUD.dismiss()

                self.cards.remove(at: index)
                self.cardRefs.remove(at: index)

                self.loadCards()
            }
        }))
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        present(confirmAlert, animated: true, completion: nil)
    }

    @IBAction func editClicked(_ sender: Any) {
        bEditing = !bEditing
        showEditButton()

        loadCards()
    }

    func addCardWith(cardInfo: Card, cardRef: DocumentReference, isAdd: Bool, cardIndex: Int) {
        if (isAdd) {
            cards.append(cardInfo)
            cardRefs.append(cardRef)
        } else {
            cards[cardIndex] = cardInfo
        }

        loadCards()
    }
}
