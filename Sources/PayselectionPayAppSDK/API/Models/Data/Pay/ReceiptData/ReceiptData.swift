//
//  ReceiptData.swift
//  Payselection-PayApp-SDK
//
//  Created by Alexander Kogalovsky on 7.11.22.
//

import Foundation

public struct ReceiptData: Codable {
    
    public var timestamp: String
    public var externalId: String?
    public var receipt: Receipt
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case externalId = "external_id"
        case receipt
    }
    
    public init(timestamp: String,
                externalId: String? = nil,
                receipt: Receipt) {
        self.timestamp = timestamp
        self.externalId = externalId
        self.receipt = receipt
    }
}
