//
//  Receipt.swift
//  
//
//  Created by Alexander Kogalovsky on 20.09.23.
//

import Foundation

public struct Receipt: Codable {
    
    public var client: Client
    public var company: Company
    public var agentInfo: AgentInfo?
    public var supplierInfo: SupplierInfo?
    public var items: [Item]
    public var payments: [Payment]
    public var vats: [Vat]?
    public var total: Double
    public var additionalCheckProps: String?
    public var cashier: String?
    public var additionalUserProps: AdditionalUserProps?
    public var operatingCheckProps: OperatingCheckProps?
    public var sectoralCheckProps: [SectoralCheckProps]?
    
    enum CodingKeys: String, CodingKey {
        case client
        case company
        case agentInfo = "agent_info"
        case supplierInfo = "supplier_info"
        case items
        case payments
        case vats
        case total
        case additionalCheckProps = "additional_check_props"
        case cashier
        case additionalUserProps = "additional_user_props"
        case operatingCheckProps = "operating_check_props"
        case sectoralCheckProps = "sectoral_check_props"
    }
    
    public init(client: Client,
                company: Company,
                agentInfo: AgentInfo? = nil,
                supplierInfo: SupplierInfo? = nil,
                items: [Item],
                payments: [Payment],
                vats: [Vat]? = nil,
                total: Double,
                additionalCheckProps: String? = nil,
                cashier: String? = nil,
                additionalUserProps: AdditionalUserProps? = nil,
                operatingCheckProps: OperatingCheckProps? = nil,
                sectoralCheckProps: [SectoralCheckProps]? = nil) {
        self.client = client
        self.company = company
        self.agentInfo = agentInfo
        self.supplierInfo = supplierInfo
        self.items = items
        self.payments = payments
        self.vats = vats
        self.total = total
        self.additionalCheckProps = additionalCheckProps
        self.cashier = cashier
        self.additionalUserProps = additionalUserProps
        self.operatingCheckProps = operatingCheckProps
        self.sectoralCheckProps = sectoralCheckProps
    }
}
