//
//  DropInViewCustomView.swift
//  Example
//

import UIKit

public final class DropInCustomView: DropInView {
    
    private(set) lazy var saveCardOptionView: SaveCardOptionView = {
        SaveCardOptionView()
    }()

    public override func setupViewHierarchy() {
        super.setupViewHierarchy()
        stackView.insertArrangedSubview(saveCardOptionView, at: 3)
    }

}
