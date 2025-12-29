//
//  Vat.swift
//  
//
//  Created by Alexander Kogalovsky on 20.09.23.
//

import Foundation

public struct Vat: Codable {
    
    public var type: VatType
    public var sum: Double?
    
    public init(type: VatType,
                sum: Double?) {
        self.type = type
        self.sum = sum
    }
}

public enum VatType: String, Codable {
    case `none` = "none"
    case vat0 = "vat0"
    case vat10 = "vat10"
    case vat110 = "vat110"
    case vat20 = "vat20"
    case vat22 = "vat22"
    case vat120 = "vat120"
    case vat122 = "vat122"
}
