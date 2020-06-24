//
//  DropInViewCustomView.swift
//  Example
//

import UIKit

public final class DropInCustomView: DropInView {
    var saveCardComponentValueChanged: ((Bool) -> Void)?
    var isSaveCardSelected: Bool = false

    var saveCardOptionView: SaveCardOptionView = {
        SaveCardOptionView()
    }()

    public override func setupViewHierarchy() {
        super.setupViewHierarchy()
        stackView.insertArrangedSubview(saveCardOptionView, at: 3)
    }

    public override func setupProperties() {
        super.setupProperties()
        saveCardOptionView.valueChanged = { [weak self] isSelected in
            self?.isSaveCardSelected = isSelected
            self?.saveCardComponentValueChanged?(isSelected)
        }
    }
}
