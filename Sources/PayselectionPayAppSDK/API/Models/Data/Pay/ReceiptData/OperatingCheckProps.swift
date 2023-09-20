//
//  OperatingCheckProps.swift
//  
//
//  Created by Alexander Kogalovsky on 20.09.23.
//

import Foundation

public struct OperatingCheckProps: Codable {
    
    public var name: String
    public var value: String
    public var timestamp: String
    
    public init(name: String,
                value: String,
                timestamp: String) {
        self.name = name
        self.value = value
        self.timestamp = timestamp
    }
}
