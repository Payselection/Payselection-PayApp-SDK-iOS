//
//  PaymentTokenFormData.swift
//  
//
//  Created by Pavel Sukalin on 23.11.23.
//

import Foundation

public enum PaymentTokenDataType: String {
    case yandex = "Yandex"
}

public class PaymentTokenFormData: PaymentFormData {
    public var type: PaymentTokenDataType
    public var payToken: String

    public init(amount: String,
              currency: String,
                  type: PaymentTokenDataType,
              payToken: String,
     messageExpiration: String,
               orderId: String,
           description: String,
          customerInfo: CustomerInfo,
           receiptData: ReceiptData? = nil,
             extraData: ExtraData? = nil,
            rebillFlag: Bool? = nil) {
        self.type = type
        self.payToken = payToken

        super.init(amount: amount, 
                   currency: currency,
                   messageExpiration: messageExpiration,
                   orderId: orderId,
                   description: description,
                   customerInfo: customerInfo,
                   receiptData: receiptData,
                   extraData: extraData,
                   rebillFlag: rebillFlag)
    }
}
