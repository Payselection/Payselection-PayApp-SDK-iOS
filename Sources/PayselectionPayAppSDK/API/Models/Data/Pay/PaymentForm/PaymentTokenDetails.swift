import Foundation

public enum PaymentTokenDataType: String {
    case yandex = "Yandex"
}

public struct PaymentTokenDetails {
    public var type: PaymentTokenDataType
    public var payToken: String

    public init(type: PaymentTokenDataType, payToken: String) {
        self.type = type
        self.payToken = payToken
    }
}
