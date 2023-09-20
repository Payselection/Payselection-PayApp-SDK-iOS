//
//  AdditionalUserProps.swift
//  
//
//  Created by Alexander Kogalovsky on 20.09.23.
//

import Foundation

public struct AdditionalUserProps: Codable {
    
    public var name: String
    public var value: String
    
    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}
