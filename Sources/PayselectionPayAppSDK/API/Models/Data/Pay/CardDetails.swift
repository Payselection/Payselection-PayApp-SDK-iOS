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
    
    enum CodingKeys: String, CodingKey {
        case cardNumber = "CardNumber"
        case expMonth = "ExpMonth"
        case expYear = "ExpYear"
        case cardholderName = "CardholderName"
        case cvc = "CVC"
    }
}
