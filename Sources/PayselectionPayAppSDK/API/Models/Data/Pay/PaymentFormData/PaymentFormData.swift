//
//  PaymentFormData.swift
//  PayselectionPayAppSDK
//
//  Created by Alexander Kogalovsky on 4.11.22.
//

import Foundation

public enum PaymentFormDataType {
    case cryptogram(PaymentCryptogramFormData)
    case token(PaymentTokenFormData)
    case qr(PaymentFormData)
    case sberPay(PaymentFormData)
    case externalForm(PaymentFormData)
    case cryptogramRSA(PaymentCryptogramFormData)

    var paymentMethod: PaymentMethod {
        switch self {
        case .cryptogram:
            return .cryptogram
        case .token:
            return .token
        case .qr:
            return .qr
        case .sberPay:
            return .sberPay
        case .externalForm:
            return .externalForm
        case .cryptogramRSA:
            return .cryptogramRSA
        }
    }
}

public class PaymentFormData {
    public var amount: String
    public var currency: String
    public var messageExpiration: String
    public var orderId: String
    public var description: String
    public var customerInfo: CustomerInfo
    public var receiptData: ReceiptData?
    public var extraData: ExtraData?
    public var rebillFlag: Bool?

    public init(amount: String, 
                currency: String,
                messageExpiration: String,
                orderId: String,
                description: String,
                customerInfo: CustomerInfo,
                receiptData: ReceiptData? = nil,
                extraData: ExtraData? = nil,
                rebillFlag: Bool? = nil) {
        self.amount = amount
        self.currency = currency
        self.messageExpiration = messageExpiration
        self.orderId = orderId
        self.description = description
        self.customerInfo = customerInfo
        self.receiptData = receiptData
        self.extraData = extraData
        self.rebillFlag = rebillFlag
    }
}
