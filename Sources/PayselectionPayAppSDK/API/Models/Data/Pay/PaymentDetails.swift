//
//  PaymentDetails.swift
//  Payselection-PayApp-SDK
//
//  Created by Alexander Kogalovsky on 7.11.22.
//

import Foundation

struct PaymentDetails: Codable {

    var value: String
    
    enum CodingKeys: String, CodingKey {
        case value = "Value"
    }
}
