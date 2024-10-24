//
//  PaymentDetails.swift
//  Payselection-PayApp-SDK
//
//  Created by Alexander Kogalovsky on 7.11.22.
//

import Foundation

struct PaymentDetails: Codable {
    
    // Cryptogram
    var cryptogramValue: String?

    // Token
    var tokenType: String?
    var tokenPay: String?

    enum CodingKeys: String, CodingKey {
        case cryptogramValue = "Value"
        case tokenType = "Type"
        case tokenPay = "PayToken"
    }
}
