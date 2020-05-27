//
//  Date.swift
//  SecureTradingCard
//

import Foundation

public extension Date {
    /// Checks if date is earlier than current date, compares only month and year components
    /// - Returns: if date is in past
    func isEarlierThanCurrentMonth() -> Bool {
        let now = Date()
        let currentComponents = Calendar.current.dateComponents([.year, .month], from: now)
        guard let nowFromComponents = Calendar.current.date(from: currentComponents) else { return false }
        return self < nowFromComponents
    }
}
