//
//  SectoralCheckProps.swift
//  
//
//  Created by Alexander Kogalovsky on 20.09.23.
//

import Foundation

public struct SectoralCheckProps: Codable {
    
    public var federalId: String
    public var date: String
    public var number: String
    public var value: String
    
    enum CodingKeys: String, CodingKey {
        case federalId = "federal_id"
        case date
        case number
        case value
    }
    
    public init(federalId: String,
                date: String,
                number: String,
                value: String) {
        self.federalId = federalId
        self.date = date
        self.number = number
        self.value = value
    }
}
