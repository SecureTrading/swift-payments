//
//  CardReferenceView.swift
//  Example
//

import UIKit
import SecureTradingCard

@objc class CardReferenceView: UIButton {
    let card: STCardReference

    var tap: ((STCardReference, Bool) -> Void)?
    init(cardReference: STCardReference) {
        self.card = cardReference
        super.init(frame: .zero)
        let cardLogo = CardType.cardType(for: card.cardType)
        self.setTitle(" - \(card.maskedPan)", for: .normal)
        self.setImage(cardLogo.logo, for: .normal)
        self.setTitleColor(UIColor.gray, for: .normal)
        self.setTitleColor(UIColor.black, for: .selected)
        self.contentHorizontalAlignment = .leading
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let touch = touches.first {
            if frame.contains(touch.location(in: superview)) {
                isSelected = !isSelected
                tap?(card, isSelected)
            }
        }
    }
}
