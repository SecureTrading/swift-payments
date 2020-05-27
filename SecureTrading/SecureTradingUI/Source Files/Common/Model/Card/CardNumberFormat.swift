//
//  CardNumberFormat.swift
//  SecureTradingUI
//

import UIKit
import SecureTradingCard

public final class CardNumberFormat {
    // MARK: Properties

    /// A card type container that is used to access accepted card types.
    private var cardTypeContainer: CardTypeContainer

    /// A separator that is used to separate different groups of the card number.
    public let separator: String

    /// Initializes an instance of the receiver.
    /// - Parameters:
    ///   - cardTypeContainer: A card type container that is used to access accepted card types.
    ///   - separator: A separator that is used to separate different groups of the card number.
    public init(cardTypeContainer: CardTypeContainer, separator: String = .space) {
        self.separator = separator
        self.cardTypeContainer = cardTypeContainer
    }

    // MARK: Functions

    /// This function removes the separator from the card number
    /// - Parameter cardNumber: The card number string
    /// - Returns: The string of card number without separators
    public func removeSeparator(cardNumber: String) -> String {
        return cardNumber.replacingOccurrences(of: self.separator, with: String.empty)
    }

    /// Formats string of card number based on the card type.
    /// - Parameter cardNumber: The unformatted string of card number
    /// - Returns: The formatted string of card number
    public func addSeparators(cardNumber: String) -> String {
        let cardType = CardValidator.cardType(for: CardNumber(rawValue: cardNumber).rawValue)
        let groups = cardType.numberGrouping
        var pattern: String?
        for groupCount in groups {
            pattern = pattern == nil ? "(\\d{1,\(groupCount)})" : pattern! + "(\\d{1,\(groupCount)})?"
        }
        guard let regex = try? NSRegularExpression(pattern: pattern ?? .empty, options: []) else { return .empty }

        let matches = regex.matches(in: cardNumber, options: [], range: NSRange(location: 0, length: cardNumber.count))
        var stringGroups = [String]()
        matches.forEach {
            for i in 1..<$0.numberOfRanges {
                let range = $0.range(at: i)
                if range.length > 0 {
                    stringGroups.append(NSString(string: cardNumber).substring(with: range))
                }
            }
        }

        return stringGroups.joined(separator: self.separator)
    }

    /// Calculates the index of a character in an unformatted string which is equivalent to the `index` in the `stringWithSeparators`.
    /// - Parameters:
    ///   - index: The index in the formatted string.
    ///   - stringWithSeparators: The formatted string.
    /// - Returns: The index of a character in an unformatted string which is equivalent to the `index` in the `stringWithSeparators`.
    private func indexInStringWithoutSeparators(index: Int, stringWithSeparators: String) -> Int {
        var componentIndex = 0
        var charCount = 0
        for component in stringWithSeparators.components(separatedBy: self.separator) {
            charCount += component.count
            guard charCount < index else { break }
            componentIndex += 1
            charCount += self.separator.count
        }

        return index - componentIndex * self.separator.count
    }

    /// Calculates the index of a character in an formatted string which is equivalent to the `index` in the `stringWithoutSeparators`.
    /// - Parameters:
    ///   - index: The index in the unformatted string.
    ///   - stringWithoutSeparators: The unformatted string.
    /// - Returns: The index of a character in an formatted string which is equivalent to the `index` in the `stringWithoutSeparators`.
    private func indexInStringWithSeparators(index: Int, stringWithoutSeparators: String) -> Int {
        var charIndex = 0
        let stringWithSeparators = self.addSeparators(cardNumber: stringWithoutSeparators)
        let groups = stringWithSeparators.components(separatedBy: self.separator)
        for i in 0..<groups.count {
            let groupChars = groups[i].count
            charIndex += groupChars
            guard charIndex >= index else { continue }
            return min(index + i * self.separator.count, stringWithSeparators.count)
        }
        return 0
    }

    /// Replaces the specified range of text in the text field with formatted string (with added separators).
    /// - Parameters:
    ///   - range: The range of the text to be replaced.
    ///   - textField: Text field, the text of which should be amended.
    ///   - string: The new string (will be formatted properly).
    public func addSeparators(range: NSRange, inTextField textField: UITextField, replaceWith string: String) {
        let newValueWithoutSeparators = self.removeSeparator(cardNumber: NSString(string: textField.text ?? .empty).replacingCharacters(in: range, with: string))
        let oldValueWithoutSeparators = self.removeSeparator(cardNumber: textField.text ?? .empty)
        let newValue = self.addSeparators(cardNumber: newValueWithoutSeparators)
        let oldValue = textField.text ?? .empty

        var position: UITextPosition?
        if let start = textField.selectedTextRange?.start {
            let oldCursorPosition = textField.offset(from: textField.beginningOfDocument, to: start)
            let oldCursorPositionWithoutSeparators = self.indexInStringWithoutSeparators(index: oldCursorPosition, stringWithSeparators: oldValue)
            let newCursorPositionWithoutSeparators = oldCursorPositionWithoutSeparators + (newValueWithoutSeparators.count - oldValueWithoutSeparators.count)
            let newCursorPositionWithSeparators = self.indexInStringWithSeparators(index: newCursorPositionWithoutSeparators, stringWithoutSeparators: newValueWithoutSeparators)

            position = textField.position(from: textField.beginningOfDocument, offset: newCursorPositionWithSeparators)
        }

        textField.text = newValue
        guard let newPosition = position else { return }
        textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
    }
}
