//
//  ServerError.swift
//  PayselectionPayAppSDK
//
//  Created by Alexander Kogalovsky on 3.11.22.
//

import Foundation

public struct ServerError: Error, Codable {
    public var code: String?
    public var description: String?

    enum CodingKeys: String, CodingKey {
        case code = "Code"
        case description = "Description"
    }
}
