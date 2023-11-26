//
//  PaymentCardService.swift
//  PayselectionPayAppDemo
//
//  Created by  on 20.11.23.
//

import UIKit
import PayselectionPayAppSDK

class PaymentCardService {
    // MARK: - Const
    struct MOC {
        static let cardAmount = "446"
        static let cardCurrency = "RUB"
        static let cardHolder = "Card Holder"
        static let cardDescription = "Demo Transaction"
        static let cardMessageExpiration = Int64(Date().timeIntervalSince1970 * 1000 + 86400000)
    }
    struct CON {
        static let cardsUserDefaultsName: String = Bundle.main.bundleIdentifier! + "cardsUserDefaultsName"
        static let merchantId: String = "20337"
        static let pubkey: String =  "04a36ce5163f6120972a6bf46a76600953ce252e8d513e4eea1f097711747e84a2b7bf967a72cf064fedc171f5effda2b899e8c143f45303c9ee68f7f562951c88"
    }
    static let instance = PaymentCardService()

    fileprivate let api = PayselectionAPI(merchantCredentials: MerchantCredentials(merchantId: CON.merchantId, publicKey: CON.pubkey))

    // MARK: - UserDefaults cards
    private(set) var cards: [PaymentCardModel] {
        get {
            guard let data = UserDefaults.standard.data(forKey: CON.cardsUserDefaultsName) else { return [] }
            return (try? JSONDecoder().decode([PaymentCardModel].self, from: data)) ?? []
        } set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(data, forKey: CON.cardsUserDefaultsName)
        }
    }

    func saveCard(_ model: PaymentCardModel) {
        var cards = self.cards
        var updatedModel = model
        updatedModel.cvc = ""
        cards.append(updatedModel)
        self.cards = cards
    }

    func updateCard(_ model: PaymentCardModel) {
        guard let card = self.cards.first(where: { $0.id == model.id }) else { return }
        removeCard(card)
        saveCard(model)
    }
    
    private func removeCard(_ model: PaymentCardModel) {
        self.cards = self.cards.filter({ $0.id != model.id })
    }

    //MARK: - Pay App
    func pay(cardNumber: String,
             cardExpMonth: String,
             cardExpYear: String,
             cvc: String,
             handlerRedirectUrl: @escaping ((String) -> Void),
             handlerError: @escaping ((Error) -> Void)) {

        let paymentFormData = PaymentCryptogramFormData(amount: MOC.cardAmount,
                                                      currency: MOC.cardCurrency,
                                                    cardNumber: cardNumber,
                                                  cardExpMonth: cardExpMonth,
                                                   cardExpYear: cardExpYear,
                                                cardHolderName: MOC.cardHolder,
                                                           cvc: cvc,
                                             messageExpiration: String(MOC.cardMessageExpiration),
                                                       orderId: UUID().uuidString,
                                                   description: MOC.cardDescription)
        api.pay(.cryptogram(paymentFormData)) { result in
            switch result {
            case .success(let payResult):
                handlerRedirectUrl(payResult.redirectUrl)
            case .failure(let error):
                handlerError(error)
            }
        }
    }

    func confirm3DSpayment(redirectUrlString: String) -> ThreeDsProcessor {
        let threeDsProcessor = ThreeDsProcessor()
        guard let url = URL(string: redirectUrlString) else { return threeDsProcessor }
        DispatchQueue.main.async {
            threeDsProcessor.confirm3DSpayment(withUrl: url)
        }
        return threeDsProcessor
    }
}
