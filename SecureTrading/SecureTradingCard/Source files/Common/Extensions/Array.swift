//
//  Array.swift
//  SecureTradingCard
//

import Foundation

extension Array {
    func getIfExists(at index: Int) -> Element? {
        guard (0..<self.count).contains(index) else { return nil }
        return self[index]
    }
}
