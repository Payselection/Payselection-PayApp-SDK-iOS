//
//  Item1_2.swift
//  
//
//  Created by on 27.11.23.
//

import Foundation

public struct Item1_2: Codable {
    public var name: String
    public var price: Double
    public var quantity: Double
    public var sum: Double
    public var paymentMethod: ReceiptPaymentMethod
    public var vat: Vat
    public var agentInfo: AgentInfo?
    public var supplierInfo: SupplierInfo?
    public var userData: String?
    public var excise: Double?
    public var countryCode: String?
    public var declarationNumber: String?
    public var paymentObject: Int
    public var measure: Int
    public var markQuantity: MarkQuantity?
    public var markProcessingMode: String?
    public var sectoralItemProps: [SectoralItemProps]?
    public var markCode: MarkCode?

    enum CodingKeys: String, CodingKey {
        case name
        case price
        case quantity
        case sum
        case paymentMethod = "payment_method"
        case vat
        case agentInfo = "agent_info"
        case supplierInfo = "supplier_info"
        case userData = "user_data"
        case excise
        case countryCode = "country_code"
        case declarationNumber = "declaration_number"
        case paymentObject = "payment_object"
        case measure
        case markQuantity = "mark_quantity"
        case markProcessingMode = "mark_processing_mode"
        case sectoralItemProps = "sectoral_item_props"
        case markCode = "mark_code"
    }
    
    public init(name: String, price: Double, quantity: Double, sum: Double, paymentMethod: ReceiptPaymentMethod, vat: Vat, agentInfo: AgentInfo? = nil, supplierInfo: SupplierInfo? = nil, userData: String? = nil, excise: Double? = nil, countryCode: String? = nil, declarationNumber: String? = nil, paymentObject: Int, measure: Int, markQuantity: MarkQuantity? = nil, markProcessingMode: String? = nil, sectoralItemProps: [SectoralItemProps]? = nil, markCode: MarkCode? = nil) {
        self.name = name
        self.price = price
        self.quantity = quantity
        self.sum = sum
        self.paymentMethod = paymentMethod
        self.vat = vat
        self.agentInfo = agentInfo
        self.supplierInfo = supplierInfo
        self.userData = userData
        self.excise = excise
        self.countryCode = countryCode
        self.declarationNumber = declarationNumber
        self.paymentObject = paymentObject
        self.measure = measure
        self.markQuantity = markQuantity
        self.markProcessingMode = markProcessingMode
        self.sectoralItemProps = sectoralItemProps
        self.markCode = markCode
    }
}
