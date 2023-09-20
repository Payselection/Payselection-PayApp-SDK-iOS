//
//  Item.swift
//  
//
//  Created by Alexander Kogalovsky on 20.09.23.
//

import Foundation

public struct Item: Codable {
    
    public var name: String
    public var price: Double
    public var quantity: Double
    public var sum: Double
    public var measurementUnit: String?
    public var paymentMethod: ReceiptPaymentMethod
    public var paymentObject: ReceiptPaymentObject
    public var nomenclatureCode: String?
    public var vat: Vat
    public var agentInfo: AgentInfo?
    public var supplierInfo: SupplierInfo?
    public var userData: String?
    public var excise: Double?
    public var countryCode: String?
    public var declarationNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case price
        case quantity
        case sum
        case measurementUnit = "measurement_unit"
        case paymentMethod = "payment_method"
        case paymentObject = "payment_object"
        case nomenclatureCode = "nomenclature_code"
        case vat
        case agentInfo = "agent_info"
        case supplierInfo = "supplier_info"
        case userData = "user_data"
        case excise
        case countryCode = "country_code"
        case declarationNumber = "declaration_number"
    }
    
    public init(name: String,
                price: Double,
                quantity: Double,
                sum: Double,
                measurementUnit: String? = nil,
                paymentMethod: ReceiptPaymentMethod,
                paymentObject: ReceiptPaymentObject,
                nomenclatureCode: String? = nil,
                vat: Vat,
                agentInfo: AgentInfo? = nil,
                supplierInfo: SupplierInfo? = nil,
                userData: String? = nil,
                excise: Double? = nil,
                countryCode: String? = nil,
                declarationNumber: String? = nil) {
        self.name = name
        self.price = price
        self.quantity = quantity
        self.sum = sum
        self.measurementUnit = measurementUnit
        self.paymentMethod = paymentMethod
        self.paymentObject = paymentObject
        self.nomenclatureCode = nomenclatureCode
        self.vat = vat
        self.agentInfo = agentInfo
        self.supplierInfo = supplierInfo
        self.userData = userData
        self.excise = excise
        self.countryCode = countryCode
        self.declarationNumber = declarationNumber
    }
}

public enum ReceiptPaymentMethod: String, Codable {
    case fullPrepayment = "full_prepayment"
    case prepayment = "prepayment"
    case advance = "advance"
    case fullPayment = "full_payment"
    case partialPayment = "partial_payment"
    case credit = "credit"
    case creditPayment = "credit_payment"
}

public enum ReceiptPaymentObject: String, Codable {
    case commodity = "commodity"
    case `excise` = "excise"
    case job = "job"
    case `service` = "service"
    case gamblingBet = "gambling_bet"
    case gamblingPrize = "gambling_prize"
    case lottery = "lottery"
    case lotteryPrize = "lottery_prize"
    case intellectualActivity = "intellectual_activity"
    case payment = "payment"
    case agentComission = "agent_commission"
    case composite = "composite"
    case award = "award"
    case another = "another"
    case propertyRight = "property_right"
    case nonOperatingGain = "non-operating_gain"
    case insurancePremiuim = "insurance_premium"
    case salesTax = "sales_tax"
    case resortFee = "resort_fee"
    case deposit = "deposit"
    case expense = "expense"
    case pensionInsuranceIp = "pension_insurance_ip"
    case pensionInsurance = "pension_insurance"
    case medicalInsuranceIp = "medical_insurance_ip"
    case medicalInsurance = "medical_insurance"
    case socialInsurance = "social_insurance"
    case casinoPayment = "casino_payment"
}
