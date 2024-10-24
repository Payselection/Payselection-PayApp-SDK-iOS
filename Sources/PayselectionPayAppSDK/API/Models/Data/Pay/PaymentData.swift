//
//  Payment.swift
//  PayselectionPayAppSDK
//
//  Created by Alexander Kogalovsky on 30.10.22.
//

import Foundation

struct PaymentData: Codable {
    var orderId: String
    var amount: String
    var currency: String
    var description: String
    var rebillFlag: Bool?
    var customerInfo: CustomerInfo
    var extraData: ExtraData?
    var paymentMethod: PaymentMethod
    var receiptData: ReceiptData?
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
        case receiptData = "ReceiptData"
        case paymentDetails = "PaymentDetails"
    }

    init(orderId: String, amount: String, currency: String, description: String, rebillFlag: Bool? = nil, customerInfo: CustomerInfo, extraData: ExtraData? = nil, paymentMethod: PaymentMethod, receiptData: ReceiptData? = nil, paymentDetails: PaymentDetails? = nil) {
        self.orderId = orderId
        self.amount = amount
        self.currency = currency
        self.description = description
        self.rebillFlag = rebillFlag
        self.customerInfo = customerInfo
        self.extraData = extraData
        self.paymentMethod = paymentMethod
        self.receiptData = receiptData
        self.paymentDetails = paymentDetails
    }
}
