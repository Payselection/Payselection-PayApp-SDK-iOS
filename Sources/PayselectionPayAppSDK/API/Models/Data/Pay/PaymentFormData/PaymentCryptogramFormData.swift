//
//  File.swift
//  
//
//  Created by Pavel Sukalin on 23.11.23.
//

import Foundation

public class PaymentCryptogramFormData: PaymentFormData {
    public var cardNumber: String
    public var cardExpMonth: String
    public var cardExpYear: String
    public var cardHolderName: String
    public var cvc: String

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
        self.cardNumber = cardNumber
        self.cardExpMonth = cardExpMonth
        self.cardExpYear = cardExpYear
        self.cardHolderName = cardHolderName
        self.cvc = cvc

        super.init(amount: amount, currency: currency, messageExpiration: messageExpiration, orderId: orderId, description: description, customerInfo: customerInfo, receiptData: receiptData, rebillFlag: rebillFlag)
    }
}
