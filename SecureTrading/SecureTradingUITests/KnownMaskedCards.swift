//
//  KnownMaskedCards.swift
//  SecureTradingUITests
//

import Foundation

struct KnownMaskedCards {
    static let visaCards = [
        "4916 4772 8705 1663",
        "4219 5281 6918 9312",
        "4539 3727 9529 2001 367"
    ]

    static let mastercardCards = [
        "2720 9912 2910 8712",
        "5319 7654 2580 6323",
        "5133 6841 2682 5306"
    ]

    static let amexCards = [
        "3420 093356 15660",
        "3757 916927 44809",
        "3707 805663 58312"
    ]

    static let discoverCards = [
        "6011 9342 1081 9607",
        "6011 0612 3744 8028",
        "6011 3119 3439 6924 735"
    ]

    static let jcbCards = [
        "3532 6473 9468 7577",
        "3530 9044 2798 3883",
        "3530 7858 5515 0495 506"
    ]

    static let dinerCards = [
        "3019 133365 7196",
        "3039 158854 9102",
        "3041 652019 8062",
        "3698 392619 5368",
        "3663 681633 9062",
        "3690 264149 5069"
    ]

    static let maestroCards = [
        "5020 2324 0660 9127",
        "6759 0551 6167 1239",
        "5018 3792 1162 6087"
    ]

    static let pibaCards = [
        "3089 5000 0000 0000 021"
    ]

    static let allCards = [visaCards, mastercardCards, amexCards, discoverCards, jcbCards, dinerCards, maestroCards, pibaCards].flatMap { $0 }

}
