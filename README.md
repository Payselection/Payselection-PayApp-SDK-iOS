## Payselection-PayApp-SDK-iOS

PaySelection PayApp SDK позволяет интегрировать прием платежей в мобильное приложение для платформы iOS.

### Требования
Для работы PaySelection PayApp SDK необходима iOS версии 13.0 или выше

### Подключение
#### SPM

```
 dependencies: [
  .package(url: "https://github.com/Payselection/Payselection-PayApp-SDK-iOS", from: "3.0.0"),
  ]
```

### Полезные ссылки

[Личный кабинет](https://merchant.payselection.com/login/)

[Разработчикам](https://api.payselection.com/#section/Request-signature)

### Структура проекта:

* **Sources/PayselectionPayAppSDK** - Исходный код SDK


### Возможности Payselection PayApp SDK:

Вы можете с помощью SDK:

* создать заказ и совершить платеж картой
* получить статуса транзакции 

### Инициализация Payselection API:

1.	Создайте экземпляр структуры с данными из личного кабинета мерчанта

```
let merchantId = "20337" // Site ID
let pubkey = "04a36ce5163f6120972a6bf46a76600953ce252e8d513e4eea1f097711747e84a2b7bf967a72cf064fedc171f5effda2b899e8c143f45303c9ee68f7f562951c88" // Публичный ключ

let merchantCreds = MerchantCredentials(merchantId: merchantId, 
                                        publicKey: pubkey)
```

2.	Создайте экземпляр PayselectionAPI для работы с API

```
let api = PayselectionAPI(merchantCredentials: merchantCreds)
```

### Оплата с использованием Payselection SDK:

1. Если необходимо, создайте экземпляр структуры CustomerInfo с информацией о клиенте.

```
let customerInfo = CustomerInfo(email: "customer@example.com")
```


2. Создайте экземпляр структуры PaymentFormData с информацией о транзакции и данными карты, передав туда customerInfo, если требуется. Внимание! Необходимо валидировать передаваемые данные, иначе сервер вернет ошибку. Подробнее о форматах можно прочесть в документации  [Payselection API](https://api.payselection.com/#section/Request-signature).

```
 let messageExpiration = String(Int64(Date().timeIntervalSince1970 * 1000 + 86400000)) // 24 часа 
 
 let paymentFormData = PaymentFormData(amount: "123",
                                       currency: .rub,
                                       cardNumber: "4129436949329530",
                                       cardExpMonth: "06",
                                       cardExpYear: "24",
                                       cardHolderName: "Card Holder",
                                       cvc: "321",
                                       messageExpiration: messageExpiration, // строковое значение времени в миллисекундах, пример получения указан выше
                                       orderId: "",                          // уникальный номер заказа. Можно использовать UUID().uuidString
                                       description: "My Transaction",        // строка должна быть не пустой, иначе сервер вернет ошибку
                                       customerInfo: customerInfo)
```

4. Вызовите метод pay

```
 api.pay(paymentFormData: paymentFormData) { result in
            switch result {
            case .success(let payResult):
                // в результате ответа приходят: transactionId, transactionSecretKey и redirectUrl
                // "transactionSecretKey" служит параметром запроса получения статуса по transactionId
                // "redirectUrl", ссылка на веб-интерфейс платежной системы 
                print(payResult)
            case .failure(let error):
                print(error)
            }
        }
        //
```

5. Отобразите WebView с полученной ссылкой на веб-интерфейс платежной системы (параметр "redirectUrl" возвращается в ответе метода "pay") удобным для вас способом. Для этого создайте объект класса ThreeDsProcessor:

```
 let threeDsProcessor = ThreeDsProcessor()
```
 и реализуйте протокол TreeDsListenerDelegate для получения объекта WKWebView и прослушивания статуса транзакции:
 
 ```
 threeDsProcessor.delegate = yourClassInstance
 
 extension YourClassName: TreeDsListenerDelegate {
 
     func willPresentWebView(_ webView: WKWebView) {
        self.webViewVC = YourWebViewController(webView: webView)
        self.present(webViewVC, animated: true)
    }
    
    func onAuthorizationCompleted() {
        webViewVC?.dismiss(animated: true)  // закройте web view в случае успеха
    }
    
    func onAuthorizationFailed(error: Error) {
        webViewVC?.dismiss(animated: true)  // закройте web view в случае неудачи
        print(error) // обработайте ошибку, если потребуется
    }
}
```

### Другие методы Payselection API:

1. Получение статуса одной транзакции

```
 api.getTransactionStatus(transactionId: payResult.transactionId,
                          transactionKey: payResult.transactionSecretKey) { result in
            switch result {
            case .success(let statusResult):
                print(statusResult)
            case .failure(let error):
                print(error)
            }
        }
```


### Поддержка

По возникающим вопросам техничечкого характера обращайтесь на support@payselection.com
