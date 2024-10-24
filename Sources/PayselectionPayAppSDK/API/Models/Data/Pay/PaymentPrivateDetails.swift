//
//  PaymentPrivateDetails.swift
//  Payselection-PayApp-SDK
//
//  Created by Alexander Kogalovsky on 7.11.22.
//

import Foundation

struct PaymentPrivateDetails: Codable {
    var transactionDetails: TransactionDetails
    var paymentMethod: PaymentMethod
    var paymentDetails: CardDetails
    var messageExpiration: String
    
    enum CodingKeys: String, CodingKey {
        case transactionDetails = "TransactionDetails"
        case paymentMethod = "PaymentMethod"
        case paymentDetails = "PaymentDetails"
        case messageExpiration = "MessageExpiration"
    }
}
