//
//  KnownCards.swift
//  SecureTradingCardTests
//
//  Created by MCHRZASTEK on 22/05/2020.
//

import Foundation

struct KnownCards {
    static let visaCards = [
        "4916477287051663",
        "4219528169189312",
        "4539372795292001367"
    ]
    
    static let mastercardCards = [
        "2720991229108712",
        "5319765425806323",
        "5133684126825306"
    ]
    
    static let amexCards = [
        "342009335615660",
        "375791692744809",
        "370780566358312"
    ]
    
    static let discoverCards = [
        "6011934210819607",
        "6011061237448028",
        "6011311934396924735"
    ]
    
    static let jcbCards = [
        "3532647394687577",
        "3530904427983883",
        "3530785855150495506"
    ]
    
    static let dinerCards = [
        "30191333657196",
        "30391588549102",
        "30416520198062",
        "36983926195368",
        "36636816339062",
        "36902641495069"
    ]
    
    static let maestroCards = [
        "5020232406609127",
        "6759055161671239",
        "5018379211626087"
    ]
    
    static let pibaCards = [
        "3089500000000000021"
    ]
    
    static let allCards = [visaCards, mastercardCards, amexCards, discoverCards, jcbCards, dinerCards, maestroCards, pibaCards].flatMap{ $0 }
    
}
