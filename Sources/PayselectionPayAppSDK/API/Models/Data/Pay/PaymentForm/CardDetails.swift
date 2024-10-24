//
//  CardDetails.swift
//  Payselection-PayApp-SDK
//
//  Created by Alexander Kogalovsky on 7.11.22.
//

import Foundation

public struct CardDetails: Codable {
    var cardNumber: String
    var expMonth: String
    var expYear: String
    var cardholderName: String
    var cvc: String

    public init(cardNumber: String, 
                expMonth: String,
                expYear: String,
                cardholderName: String,
                cvc: String) {
        self.cardNumber = cardNumber
        self.expMonth = expMonth
        self.expYear = expYear
        self.cardholderName = cardholderName
        self.cvc = cvc
    }

    enum CodingKeys: String, CodingKey {
        case cardNumber = "CardNumber"
        case expMonth = "ExpMonth"
        case expYear = "ExpYear"
        case cardholderName = "CardholderName"
        case cvc = "CVC"
    }
}
