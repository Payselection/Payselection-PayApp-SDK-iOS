//
//  ReceiptData.swift
//  Payselection-PayApp-SDK
//
//  Created by Alexander Kogalovsky on 7.11.22.
//

import Foundation

public final class ReceiptFFD1_05Data: ReceiptData {

    public var receipt: ReceiptFfd1_05

    enum CodingKeys: String, CodingKey {
        case receipt
    }

    public init(timestamp: String, externalId: String? = nil, receipt: ReceiptFfd1_05) {
        self.receipt = receipt
        super.init(timestamp: timestamp, externalId: externalId)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.receipt = try container.decode(ReceiptFfd1_05.self, forKey: .receipt)
        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(receipt, forKey: .receipt)
        try super.encode(to: encoder)
    }
}

public final class ReceiptFFD1_2Data: ReceiptData {

    public var receipt: ReceiptFfd1_2

    enum CodingKeys: String, CodingKey {
        case receipt
    }

    public init(timestamp: String, externalId: String? = nil, receipt: ReceiptFfd1_2) {
        self.receipt = receipt
        super.init(timestamp: timestamp, externalId: externalId)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.receipt = try container.decode(ReceiptFfd1_2.self, forKey: .receipt)
        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(receipt, forKey: .receipt)
        try super.encode(to: encoder)
    }
}

public class ReceiptData: Codable {

    public var timestamp: String
    public var externalId: String?

    enum CodingKeys: String, CodingKey {
        case timestamp
        case externalId = "external_id"
    }

    public init(timestamp: String, externalId: String? = nil) {
        self.timestamp = timestamp
        self.externalId = externalId
    }
}
