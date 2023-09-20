//
//  PaymentFormData.swift
//  PayselectionPayAppSDK
//
//  Created by Alexander Kogalovsky on 4.11.22.
//

import Foundation

public struct PaymentFormData {
    
    public var amount: String
    public var currency: String
    public var cardNumber: String
    public var cardExpMonth: String
    public var cardExpYear: String
    public var cardHolderName: String
    public var cvc: String
    public var messageExpiration: String
    public var orderId: String
    public var description: String
    public var customerInfo: CustomerInfo?
    public var receiptData: ReceiptData?
    public var rebillFlag: Bool?
    
    public init(amount: String,
                currency: String,
                cardNumber: String,
                cardExpMonth: String,
                cardExpYear: String,
                cardHolderName: String,
                cvc: String,
                messageExpiration: String,
                orderId: String,
                description: String,
                customerInfo: CustomerInfo? = nil,
                receiptData: ReceiptData? = nil,
                rebillFlag: Bool? = nil) {
        self.amount = amount
        self.currency = currency
        self.cardNumber = cardNumber
        self.cardExpMonth = cardExpMonth
        self.cardExpYear = cardExpYear
        self.cardHolderName = cardHolderName
        self.cvc = cvc
        self.messageExpiration = messageExpiration
        self.orderId = orderId
        self.description = description
        self.customerInfo = customerInfo
        self.receiptData = receiptData
        self.rebillFlag = rebillFlag
    }
}
