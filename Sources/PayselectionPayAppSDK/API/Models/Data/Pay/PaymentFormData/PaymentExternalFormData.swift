
import Foundation

public class PaymentExternalFormData: PaymentFormData {
    public override init(amount: String,
                       currency: String,
              messageExpiration: String,
                        orderId: String,
                    description: String,
                   customerInfo: CustomerInfo,
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
