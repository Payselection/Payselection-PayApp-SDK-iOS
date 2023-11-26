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
    var paymentDetails: PaymentDetails
    
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
}

enum PaymentMethod: String, Codable {
    case cryptogram = "Cryptogram"
    case token = "Token"
    case qr = "QR"
}















