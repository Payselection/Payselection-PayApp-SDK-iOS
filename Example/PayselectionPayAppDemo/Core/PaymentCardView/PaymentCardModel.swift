//
//  PaymentCardModel.swift
//  PayselectionPayAppDemo
//
//  Created by  on 20.11.23.
//

import UIKit

enum PaymentCardType: Int {
    case mir = 2
    case visa = 4
    case mastercard = 5
    case other
}

struct PaymentCardModel: Codable {
    static let cardCharacterCount: Int = 16

    var id: String = UUID().uuidString
    let cardNumber: String
    let cardExpMonth: String
    let cardExpYear: String
    var cvc: String

    var type: PaymentCardType {
        PaymentCardModel.typeByPrefix(String(cardNumber.prefix(1)))
    }

    var typeLogoName: String? {
        PaymentCardModel.logoNameByType(type)
    }

    var last4Digits: String {
        String(cardNumber.suffix(4))
    }

    static func typeByPrefix(_ prefix: String) -> PaymentCardType {
        PaymentCardType(rawValue: Int(prefix) ?? 0) ?? .other
    }

    static func logoNameByType(_ type: PaymentCardType) -> String? {
        switch type {
            case .mir: "mirCard"
            case .visa: "visaCard"
            case .mastercard: "masterCard"
            case .other: nil
        }
    }

    static func typeNameCardByNumber(_ cardNumber: String) -> String? {
        switch PaymentCardModel.typeByPrefix(String(cardNumber.prefix(1))) {
            case .mir: "Мир"
            case .visa: "Visa"
            case .mastercard: "MasterCard"
            case .other: nil
        }
    }

    static func validateCardNumber(_ cardNumber: String) -> Bool {
        let strippedCardNumber = cardNumber.replacingOccurrences(of: " ", with: "")
        guard strippedCardNumber.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil else {
            return false
        }
        guard strippedCardNumber.count == cardCharacterCount else {
            return false
        }
        let digits = strippedCardNumber.compactMap { Int(String($0)) }
        // Apply the Luhn algorithm
        var sum = 0
        for (index, digit) in digits.reversed().enumerated() {
            if index % 2 == 1 {
                let doubledDigit = digit * 2
                sum += doubledDigit > 9 ? doubledDigit - 9 : doubledDigit
            } else {
                sum += digit
            }
        }
        return sum % 10 == 0
    }
}

