//
//  WhiteBackgroundBaseView.swift
//  SecureTradingUI
//

import UIKit

public class WhiteBackgroundBaseView: BaseView {
    /// Initialize an instance and sets background image
    public override init() {
        super.init()
        backgroundColor = UIColor.white
    }

    /// - SeeAlso: NSCoding.init?(coder:)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
