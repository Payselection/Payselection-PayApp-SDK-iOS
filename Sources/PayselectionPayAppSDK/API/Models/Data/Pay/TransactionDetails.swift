//
//  TransactionDetails.swift
//  Payselection-PayApp-SDK
//
//  Created by Alexander Kogalovsky on 7.11.22.
//

import Foundation

struct TransactionDetails: Codable {
    var amount: String
    var currency: String
    
    enum CodingKeys: String, CodingKey {
        case amount = "Amount"
        case currency = "Currency"
    }
}
