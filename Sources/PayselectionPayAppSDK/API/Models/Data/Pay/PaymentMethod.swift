//
//  Created by Alexander Kogalovsky on 24.10.24.
//

import Foundation

enum PaymentMethod: String, Codable {
    case cryptogram = "Cryptogram"
    case token = "Token"
    case qr = "QR"
    case sberPay = "SberPay"
    case externalForm = "ExternalForm"
    case cryptogramRSA = "CryptogramRSA"
}
