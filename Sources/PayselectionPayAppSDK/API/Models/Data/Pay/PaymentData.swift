//
//  Payment.swift
//  PayselectionPayAppSDK
//
//  Created by Alexander Kogalovsky on 30.10.22.
//

import Foundation


class PaymentData: Codable {

    var orderId: String
    var amount: String
    var currency: String
    var description: String
    var rebillFlag: Bool?
    var customerInfo: CustomerInfo
    var extraData: ExtraData?
    var paymentMethod: PaymentMethod
    var paymentDetails: PaymentDetails?

    enum CodingKeys: String, CodingKey {
        case orderId = "OrderId"
        case amount = "Amount"
        case currency = "Currency"
        case description = "Description"
        case rebillFlag = "RebillFlag"
        case customerInfo = "CustomerInfo"
        case extraData = "ExtraData"
        case paymentMethod = "PaymentMethod"
        case paymentDetails = "PaymentDetails"
    }

    init(orderId: String, amount: String, currency: String, description: String, rebillFlag: Bool? = nil, customerInfo: CustomerInfo, extraData: ExtraData? = nil, paymentMethod: PaymentMethod, paymentDetails: PaymentDetails? = nil) {
        self.orderId = orderId
        self.amount = amount
        self.currency = currency
        self.description = description
        self.rebillFlag = rebillFlag
        self.customerInfo = customerInfo
        self.extraData = extraData
        self.paymentMethod = paymentMethod
        self.paymentDetails = paymentDetails
    }
}

final class PaymentFFD1_05Data: PaymentData {

    var receiptData: ReceiptFFD1_05Data

    enum CodingKeys: String, CodingKey {
        case receiptData = "ReceiptData"
    }

    init(paymentData: PaymentData, receiptData: ReceiptFFD1_05Data) {
        self.receiptData = receiptData
        
        super.init(orderId: paymentData.orderId, amount: paymentData.amount, currency: paymentData.currency, description: paymentData.description, rebillFlag: paymentData.rebillFlag, customerInfo: paymentData.customerInfo, extraData: paymentData.extraData, paymentMethod: paymentData.paymentMethod, paymentDetails: paymentData.paymentDetails)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.receiptData = try container.decode(ReceiptFFD1_05Data.self, forKey: .receiptData)
        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(receiptData, forKey: .receiptData)
        try super.encode(to: encoder)
    }
}

final class PaymentFFD1_2Data: PaymentData {

    var receiptData: ReceiptFFD1_2Data

    enum CodingKeys: String, CodingKey {
        case receiptData = "ReceiptData"
    }

    init(paymentData: PaymentData, receiptData: ReceiptFFD1_2Data) {
        self.receiptData = receiptData

        super.init(orderId: paymentData.orderId, amount: paymentData.amount, currency: paymentData.currency, description: paymentData.description, rebillFlag: paymentData.rebillFlag, customerInfo: paymentData.customerInfo, extraData: paymentData.extraData, paymentMethod: paymentData.paymentMethod, paymentDetails: paymentData.paymentDetails)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.receiptData = try container.decode(ReceiptFFD1_2Data.self, forKey: .receiptData)
        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(receiptData, forKey: .receiptData)
        try super.encode(to: encoder)
    }
}

enum PaymentMethod: String, Codable {
    case cryptogram = "Cryptogram"
    case token = "Token"
    case qr = "QR"
}
