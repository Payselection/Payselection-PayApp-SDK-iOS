//
//  Payment.swift
//  
//
//  Created by Alexander Kogalovsky on 20.09.23.
//

import Foundation

public struct Payment: Codable {
    
    public var type: PaymentType
    public var sum: Double
    
    public init(type: PaymentType, sum: Double) {
        self.type = type
        self.sum = sum
    }
}

public enum PaymentType: Int, Codable {
    case _0
    case _1
    case _2
    case _3
    case _4
}
