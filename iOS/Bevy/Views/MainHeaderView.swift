//
//  MainHeaderView.swift
//  Bevy
//
//  Created by macOS on 6/27/20.
//  Copyright © 2020 Nathan Ellis. All rights reserved.
//

import UIKit

@IBDesignable
class MainHeaderView: UIView {

    let nibName = "MainHeaderView"
    var contentView: UIView?

    @IBOutlet weak var label: UILabel!
    @IBAction func buttonTap(_ sender: UIButton) {
        label.text = "Hi"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
    }

    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
