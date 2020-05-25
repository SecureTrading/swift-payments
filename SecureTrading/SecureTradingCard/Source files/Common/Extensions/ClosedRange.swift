//
//  ClosedRange.swift
//  SecureTradingCard
//
//

import Foundation

extension ClosedRange where Bound == Int {
    /// Constructs a new array containing ranges that are not in the range of caller
    /// - Parameter subrange: ClosedRange for exclusion
    /// - Returns: Array of CloseRange elements that are not in the range of caller
    func remove(range subrange: ClosedRange<Int>) -> [ClosedRange<Int>] {
        // 1...10 / 3...8 -> [1...2, 9...10]
        guard subrange.lowerBound > self.lowerBound else { return [] }
        let prefix = self.lowerBound...(subrange.lowerBound - 1)
        guard self.upperBound > subrange.upperBound else { return [prefix]}
        let suffix = (subrange.upperBound + 1)...self.upperBound
        return [prefix, suffix]
    }
}

extension Array where Element == ClosedRange<Int> {
    func except(ranges: [Element]) -> [Element] {
        var newRanges: [Element] = []
        var split = false
        // goes throught all ranges and subranges
        // then checks if main range contains dividing range
        // if so, divides main range to exclude subrange
        for mainRange in self.sorted(by: {$0.lowerBound < $1.lowerBound}) {
            let sortedRanges = ranges.sorted { $0.lowerBound < $1.lowerBound }
            for subRange in sortedRanges {
                if mainRange.contains(subRange.lowerBound) {
                    // split
                    let diff = mainRange.remove(range: subRange)
                    newRanges.append(contentsOf: diff)
                    split = true
                }
            }
            // if range wasn't modified a.k.a splitted
            // then append oryginal range to new array
            if split == false {
                newRanges.append(mainRange)
            }
            split = false
        }
        
        // newRanges array contains ranges that may overlap
        // especially if were divided by multiple ranges
        // 1...10 / [2...5, 7...8] -> [1...1, 6...10, 1...6, 9...10]
        // The loop below checkes elements next to each other and adjust
        // their lower and upper ranges, so at the end it look like this
        // 1...10 / [2...5, 7...8] -> [1...1, 6...6, 9...10]
        
        var normalizedRanges: [Element] = []
        for (index, range) in newRanges.enumerated() {
            if range.upperBound == normalizedRanges.last?.upperBound {
                // skips adding range that has the same upper bound
                // like the previous range
                // comparing to example above, this avoids 1...6 from adding
                continue
            }
            
            if let next = newRanges.getIfExists(at: index + 1) {
                if range.upperBound > next.upperBound {
                    // modifies range so the upper bound is greater than next range
                    // comparing to example above, this replaces 6...10 -> 6...6
                    let newRange = range.lowerBound...next.upperBound
                    normalizedRanges.append(newRange)
                } else {
                    // nothing to change, add oryginal range
                    normalizedRanges.append(range)
                }
            } else {
                // nothing to change, add oryginal range
                normalizedRanges.append(range)
            }
        }
        return normalizedRanges
    }
}
