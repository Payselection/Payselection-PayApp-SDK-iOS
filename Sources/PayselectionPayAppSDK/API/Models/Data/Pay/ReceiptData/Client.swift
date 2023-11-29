//
//  Client.swift
//  
//
//  Created by Alexander Kogalovsky on 20.09.23.
//

import Foundation

public struct Client: Codable {

    public var name: String?
    public var inn: String?
    public var email: String?
    public var phone: String?

    public init(name: String? = nil,
                inn: String? = nil,
                email: String? = nil,
                phone: String? = nil) {
        self.name = name
        self.inn = inn
        self.email = email
        self.phone = phone
    }
}
