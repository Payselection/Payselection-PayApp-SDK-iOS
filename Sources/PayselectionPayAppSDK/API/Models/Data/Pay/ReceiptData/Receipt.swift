//
//  Receipt.swift
//  
//
//  Created by Alexander Kogalovsky on 20.09.23.
//

import Foundation

public enum ReceiptType {
    case ffd1_05(timestamp: String, externalId: String, receipt: ReceiptFfd1_05)
    case ffd1_2(timestamp: String, externalId: String, receipt: ReceiptFfd1_2)
}

public final class ReceiptFfd1_05: Receipt {

    public var agentInfo: AgentInfo?
    public var supplierInfo: SupplierInfo?
    public var items: [Item1_05]
    
    enum CodingKeys: String, CodingKey {
        case agentInfo = "agent_info"
        case supplierInfo = "supplier_info"
        case items
    }

    public init(client: Client,
                company: Company,
                payments: [Payment],
                vats: [Vat]? = nil,
                total: Double,
                additionalCheckProps: String? = nil,
                cashier: String? = nil,
                additionalUserProps: AdditionalUserProps? = nil,
                agentInfo: AgentInfo? = nil,
                supplierInfo: SupplierInfo? = nil,
                items: [Item1_05]) {
        self.agentInfo = agentInfo
        self.supplierInfo = supplierInfo
        self.items = items

        super.init(client: client,
                   company: company,
                   payments: payments, 
                   vats: vats,
                   total: total,
                   additionalCheckProps: additionalCheckProps,
                   cashier: cashier,
                   additionalUserProps: additionalUserProps)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.agentInfo = try container.decode(AgentInfo.self, forKey: .agentInfo)
        self.supplierInfo = try container.decode(SupplierInfo.self, forKey: .supplierInfo)
        self.items = try container.decode([Item1_05].self, forKey: .items)
        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(agentInfo, forKey: .agentInfo)
        try container.encode(supplierInfo, forKey: .supplierInfo)
        try container.encode(items, forKey: .items)
        try super.encode(to: encoder)
    }
}

public final class ReceiptFfd1_2: Receipt {

    public var items: [Item1_2]
    public var operatingCheckProps: OperatingCheckProps?
    public var sectoralCheckProps: [SectoralCheckProps]?

    enum CodingKeys: String, CodingKey {
        case operatingCheckProps = "operating_check_props"
        case sectoralCheckProps = "sectoral_check_props"
        case items
    }

    public init(client: Client, 
                company: Company,
                payments: [Payment],
                vats: [Vat]? = nil,
                total: Double,
                additionalCheckProps: String? = nil, 
                cashier: String? = nil,
                additionalUserProps: AdditionalUserProps? = nil,
                items: [Item1_2],
                operatingCheckProps: OperatingCheckProps? = nil,
                sectoralCheckProps: [SectoralCheckProps]? = nil) {
        self.items = items
        self.operatingCheckProps = operatingCheckProps
        self.sectoralCheckProps = sectoralCheckProps

        super.init(client: client, company: company, payments: payments, vats: vats, total: total, additionalCheckProps: additionalCheckProps, cashier: cashier, additionalUserProps: additionalUserProps)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.operatingCheckProps = try container.decode(OperatingCheckProps.self, forKey: .operatingCheckProps)
        self.sectoralCheckProps = try container.decode([SectoralCheckProps].self, forKey: .sectoralCheckProps)
        self.items = try container.decode([Item1_2].self, forKey: .items)
        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(operatingCheckProps, forKey: .operatingCheckProps)
        try container.encode(sectoralCheckProps, forKey: .sectoralCheckProps)
        try container.encode(items, forKey: .items)
        try super.encode(to: encoder)
    }
}

public class Receipt: Codable {

    public var client: Client
    public var company: Company
    public var payments: [Payment]
    public var vats: [Vat]?
    public var total: Double
    public var additionalCheckProps: String?
    public var cashier: String?
    public var additionalUserProps: AdditionalUserProps?

    enum CodingKeys: String, CodingKey {
        case client
        case company
        case payments
        case vats
        case total
        case additionalCheckProps = "additional_check_props"
        case cashier
        case additionalUserProps = "additional_user_props"
    }

    public init(client: Client,
                company: Company,
                payments: [Payment],
                vats: [Vat]? = nil,
                total: Double,
                additionalCheckProps: String? = nil,
                cashier: String? = nil,
                additionalUserProps: AdditionalUserProps? = nil) {
        self.client = client
        self.company = company
        self.payments = payments
        self.vats = vats
        self.total = total
        self.additionalCheckProps = additionalCheckProps
        self.cashier = cashier
        self.additionalUserProps = additionalUserProps
    }
}
