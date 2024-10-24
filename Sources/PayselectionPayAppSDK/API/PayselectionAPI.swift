//
//  PaySelectionApi.swift
//  PayselectionPayAppSDK
//
//  Created by Alexander Kogalovsky on 31.10.22.
//

import Foundation
import CryptoKit

public class PayselectionAPI {
    public typealias PayselectionRequestCompletion<T> = (Result<T, Error>) -> Void

    private let merchantCreds: MerchantCredentials
    public var xReqId: String = ""

    public init(merchantCredentials: MerchantCredentials) {
        self.merchantCreds = merchantCredentials
    }

    public func pay(paymentForm: PaymentFormData,
                    completion: @escaping PayselectionRequestCompletion<PayResult>) {
        var paymentDetails: PaymentDetails? = nil
        // type
        switch paymentForm.type {
        case .cryptogram(let cardDetails):
            let transactionDetails = TransactionDetails(amount: paymentForm.amount, currency: paymentForm.currency)
            let secretPaymentDetails = PaymentPrivateDetails(transactionDetails: transactionDetails,
                                                                  paymentMethod: .cryptogram,
                                                                 paymentDetails: cardDetails,
                                                              messageExpiration: paymentForm.messageExpiration)

            guard let token = try? Encryptor().makeCryptogram(publicKey: merchantCreds.publicKey,
                                                              privateDetails: secretPaymentDetails) else {
                completion(.failure(PayselectionError.encryptionError))
                return
            }
            paymentDetails = PaymentDetails(cryptogramValue: token)
        case .token(let tokenDetails):
            paymentDetails = PaymentDetails(tokenType: tokenDetails.type.rawValue, tokenPay: tokenDetails.payToken)
        case .cryptogramRSA(let cardDetails):
            let transactionDetails = TransactionDetails(amount: paymentForm.amount, currency: paymentForm.currency)
            let secretPaymentDetails = PaymentPrivateDetails(transactionDetails: transactionDetails,
                                                                  paymentMethod: .cryptogramRSA,
                                                                 paymentDetails: cardDetails,
                                                              messageExpiration: paymentForm.messageExpiration)

            guard let token = Encryptor().makeCryptogramRSA(publicKey: merchantCreds.publicRSAKey, privateDetails: secretPaymentDetails) else {
                completion(.failure(PayselectionError.encryptionError))
                return
            }
            paymentDetails = PaymentDetails(cryptogramValue: token)
        default:
            break
        }

        let paymentData = PaymentData(orderId: paymentForm.orderId,
                                      amount: paymentForm.amount,
                                      currency: paymentForm.currency,
                                      description: paymentForm.description,
                                      rebillFlag: paymentForm.rebillFlag,
                                      customerInfo: paymentForm.customerInfo,
                                      extraData: paymentForm.extraData,
                                      paymentMethod: paymentForm.type.paymentMethod,
                                      receiptData: paymentForm.receiptData,
                                      paymentDetails: paymentDetails)

        guard let requestBodyString = self.getRequestBody(from: paymentData) else { return }

        let headers = self.generatePayHeaders(merchantId: self.merchantCreds.merchantId,
                                              requestURL: PayselectionHTTPResource.pay.rawValue,
                                              requestBody: requestBodyString)
        let request = PayRequest(path: self.merchantCreds.networkConfig.serverUrl,
                                 body: paymentData,
                                 headers: headers)
        request.execute(
            onSuccess: { result in
                completion(.success(result))
            }, onError: { error in
                completion(.failure(error))
        })
    }

    public func getTransactionStatus(transactionId: String,
                                     transactionKey: String,
                                     completion: @escaping PayselectionRequestCompletion<StatusResult>) {
        
        let headers = generateTransactionsHeader(merchantId: merchantCreds.merchantId,
                                                 httpMethod: .get,
                                                 requestURL: PayselectionHTTPResource.transactionStatus.rawValue.appending(transactionId),
                                                 transactionKey: transactionKey,
                                                 requestBody: nil)

        let request = TransactionStatusRequest(path: self.merchantCreds.networkConfig.serverUrl,
                                               body: nil,
                                               headers: headers,
                                               orderId: transactionId)
        request.execute(
            onSuccess: { result in
                completion(.success(result))
            },
            onError: { error in
                completion(.failure(error))
            })
    }
    
    private func generatePayHeaders(merchantId: String,
                                    requestURL: String,
                                    requestBody: String?) -> [String: String] {
        var headers = [String: String]()
        headers["X-SITE-ID"] = merchantId
        headers["X-REQUEST-ID"] = UUID().uuidString
        xReqId = headers["X-REQUEST-ID"] ?? ""

        return headers
    }
    
    private func generateTransactionsHeader(merchantId: String,
                                            httpMethod: HTTPMethod,
                                            requestURL: String,
                                            transactionKey: String,
                                            requestBody: String?) -> [String: String] {
        
        var headers = [String: String]()
        headers["X-REQUEST-AUTH"] = "public"
        headers["X-SITE-ID"] = merchantId
        headers["X-REQUEST-ID"] = UUID().uuidString
        guard let xRequestId = headers["X-REQUEST-ID"] else { return [:] }
        headers["X-REQUEST-SIGNATURE"] = getXRequestSignature(httpMethod: httpMethod,
                                                              requestURL: requestURL,
                                                              xSiteId: merchantId,
                                                              xRequestId:  xRequestId,
                                                              secretKey:  transactionKey,
                                                              requestBody: nil)
        
        return headers
    }
    
    private func getRequestBody(from object: Codable) -> String? {
        do {
            let body = try getJSONString(from: object)
            return body
        } catch {
            return nil
        }
    }
    
    private func getJSONString(from object: Codable) throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .withoutEscapingSlashes
        do {
            let data = try encoder.encode(object)
            return String(data: data, encoding: .utf8)!
        } catch {
            throw error
        }
    }
    
    private func getXRequestSignature(httpMethod: HTTPMethod,
                                      requestURL: String,
                                      xSiteId: String,
                                      xRequestId: String,
                                      secretKey: String,
                                      requestBody: String?) -> String {
        
        let signatureBody = "\(httpMethod.rawValue)\n\(requestURL)\n\(xSiteId)\n\(xRequestId)\n\(requestBody ?? "")"
        let sign = getHMACsignature(for: signatureBody, key: secretKey)
        return sign
    }
    
    private func getHMACsignature(for plaintext: String, key: String) -> String {
        let key = SymmetricKey(data: Data(key.utf8))
        let signature = HMAC<SHA256>.authenticationCode(for: Data(plaintext.utf8), using: key)
        let signatureString = Data(signature).map { String(format: "%02hhx", $0) }.joined()
        return signatureString
    }
    
    private func getIPAddress() -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }

                guard let interface = ptr?.pointee else { return "" }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                    // wifi = ["en0"]
                    // wired = ["en2", "en3", "en4"]
                    // cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]

                    let name: String = String(cString: (interface.ifa_name))
                    if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address
    }
}

