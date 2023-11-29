//
//  PaymentQRFormData.swift
//  
//
//  Created by Pavel Sukalin on 23.11.23.
//

import Foundation

public class PaymentQRFormData: PaymentFormData {
    public override init(amount: String,
                       currency: String,
              messageExpiration: String,
                        orderId: String,
                    description: String,
                   customerInfo: CustomerInfo? = nil,
                    receiptData: ReceiptData? = nil,
                      extraData: ExtraData? = nil,
                     rebillFlag: Bool? = nil) {
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
