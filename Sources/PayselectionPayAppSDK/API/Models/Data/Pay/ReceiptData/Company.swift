//
// Company.swift
//  
//
//  Created by Alexander Kogalovsky on 20.09.23.
//

import Foundation

public struct Company: Codable {
    
    public var email: String?
    public var sno: String?
    public var inn: String
    public var paymentAddress: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case sno
        case inn
        case paymentAddress = "payment_address"
    }
    
    public init(email: String? = nil,
                sno: String? = nil,
                inn: String,
                paymentAddress: String) {
        self.email = email
        self.sno = sno
        self.inn = inn
        self.paymentAddress = paymentAddress
    }
}
