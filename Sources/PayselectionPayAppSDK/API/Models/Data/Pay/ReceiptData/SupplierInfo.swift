//
//  SupplierInfo.swift
//  
//
//  Created by Alexander Kogalovsky on 20.09.23.
//

import Foundation

public struct SupplierInfo: Codable {
    
    public var phones: [String]?
    public var name: String?
    public var inn: String?
    
    public init(phones: [String]? = nil,
                name: String? = nil,
                inn: String? = nil) {
        self.phones = phones
        self.name = name
        self.inn = inn
    }
}
