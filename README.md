## Payselection-PayApp-SDK-iOS

PaySelection PayApp SDK позволяет интегрировать прием платежей в мобильное приложение для платформы iOS.

### Требования
Для работы PaySelection PayApp SDK необходима iOS версии 13.0 или выше

### Подключение
#### SPM

```
 dependencies: [
  .package(url: "https://github.com/Payselection/Payselection-PayApp-SDK-iOS", from: "3.3.1"),
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
let pubkeyRSA = "LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUlJQ0lqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FnOEFNSUlDQ2dLQ0FnRUFxbk56eXlwR1R6cENZeDlzMnh6RQpaQ3B4eVkyL2YrbWljb0drWW1rV0M5Szl2SlIvcEtUL0VOUThCT1hIRkFBYW5Mb05PNzVLcmJUQ3Z5Y2pXbkJGCnhYQlJZY2NWeGsxaVB0c0VKbkNlcThmYXMwa2dYMFgzLzFnTFdvbkhheVdTUUl5emFTMXMrWUdsNEJyd2s5c08KTTQyZlk0dkM1WGptU1YxUDNlN2pvNUN1d2hxL2ljUkxZbTg1MXBYRTRiZ3FZYS96NEsrbXhUcWJvdC94b3lhTQpxSmlIOS9EUnQveTc0Z2t6Q0VIRThGQ0M4TkJlVXZUckRWbnlSQ0dtSlpVTDh0QnhPd1N3Ty94M1lzZi9CNU9vCkVjbllWdjVSQmF1MDl4VmFGTFN5QkZiRUsvZnRDUktFeUNQbnpYS2FnbTQ3T2dROEIvTkdhQ0cxRmdVOUhJb2gKd093TmsycWY1NTRPR21Oa0E3MnZCR1E0RTZ4TldUSnFJQWhOTUJQTjFMZGdRNXZTamszTUVJRHQ3Y3FEZzhFRwpCNU0vVS9VT2lVU2tXWmFtR3pXOVZFbkJhRFdWZFpxVVpTc0d0aCtJM093NGRPUUxiZG4rdzljYlpHLzR2VmwvCmFKdTdlQlZ2WVhEL0o0TnIzMk5RZ1o2YzlpMCtNU3RwWFUxMlJ4bzhJK1hCNVpZUTkzNE5iVXJoeDBuMlJhQk0KbGtlSTFtbE1ncWI3ME9BRk5zaDUyNUFIL3k5OVpJTzhsR0RqVEpSdDlKZzdGNVFmUEVWekRIbXdxdy9FaFFjQwpjVG5QaGRLOE53NDJ3QldIVDhXYXg4Y1NxYTdwRytTM2JOYkZvUVJlU1dvK2pzV0JNOU1NemJvckNqYWE1UzRNCnNCV0UyN2FRSElVMU5sTGNqK0laUldzQ0F3RUFBUT09Ci0tLS0tRU5EIFBVQkxJQyBLRVktLS0tLQo" // Публичный ключ RSA

let merchantCreds = MerchantCredentials(merchantId: merchantId, 
                                        publicKey: pubkey
                                        publicRSAKey: pubkeyRSA)
```

2.	Создайте экземпляр PayselectionAPI для работы с API

```
let api = PayselectionAPI(merchantCredentials: merchantCreds)
```

### Оплата с использованием Payselection SDK:

1. Cоздайте экземпляр структуры CustomerInfo с информацией о клиенте.

```
let customerInfo = CustomerInfo(email: "user@example.com",
                                receiptEmail: "user@example.com", 
                                isSendReceipt: true,
                                phone: "+19991231212",
                                language: "en",
                                address: "string",
                                town: "string",
                                zip: "string",
                                country: "USA",
                                ip: "8.8.8.8",  // обязательное поле
                                userId: "string")
```


2. Создайте экземпляр структуры PaymentFormData с информацией о транзакции и данными карты, передав туда customerInfo, а также экземпляры ReceiptData и ExtraData, если требуется. Внимание! Необходимо валидировать передаваемые данные, иначе сервер вернет ошибку. Подробнее о форматах можно прочесть в документации  [Payselection API](https://api.payselection.com/#section/Request-signature).

```
 let messageExpiration = String(Int64(Date().timeIntervalSince1970 * 1000 + 86400000)) // 24 часа 
 
 let cardDetails = CardDetails(cardNumber: "4129436949329530",
                              expMonth: "01",
                              expYear: "25",
                              cardholderName: "Card Holder",
                              cvc: "411")
                              
 let paymentFormData = PaymentFormData(type: .cryptogram(cardDetails),
                                       amount: "123",
                                       currency: "RUB",
                                       messageExpiration: messageExpiration, // строковое значение времени в миллисекундах, пример получения указан выше
                                       orderId: "", // уникальный номер заказа. Можно использовать UUID().uuidString,
                                       description: "My Transaction",  // строка должна быть не пустой, иначе сервер вернет ошибку
                                       customerInfo: customerInfo,
                                       receiptData: receiptData,
                                       extraData: extraData(),
                                       rebillFlag: false)
```

4. Вызовите метод pay

```
  api.pay(paymentFormData) { result in
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
```

5. Отобразите WebView с полученной ссылкой на веб-интерфейс платежной системы (параметр "redirectUrl" возвращается в ответе метода "pay") удобным для вас способом. Для этого создайте объект класса ThreeDsProcessor:

```
 let threeDsProcessor = ThreeDsProcessor()
```
 и реализуйте протокол ThreeDsListenerDelegate для получения объекта WKWebView и прослушивания статуса транзакции:
 
 ```
 threeDsProcessor.delegate = yourClassInstance
 
 extension YourClassName: ThreeDsListenerDelegate {
 
     func willPresentWebView(_ webView: WKWebView) {
        self.webViewVC = YourWebViewController(webView: webView)
        self.present(webViewVC, animated: true)
    }
    
    func onAuthorizationCompleted() {
        self.webViewVC.dismiss(animated: true)  // закройте web view в случае успеха
    }
    
    func onAuthorizationFailed(error: Error) {
        self.webViewVC.dismiss(animated: true)  // закройте web view в случае неудачи
        print(error) // обработайте ошибку, если потребуется
    }
}
```
совершите подтверждение платежа:

```
 guard let url = URL(string: payResult.redirectUrl) else { return }
 threeDsProcessor.confirm3DSpayment(withUrl: url) 
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
