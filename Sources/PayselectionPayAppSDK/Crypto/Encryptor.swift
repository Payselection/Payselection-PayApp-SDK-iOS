//
//  Encryptor.swift
//  PayselectionPayAppSDK
//
//  Created by Alexander Kogalovsky on 25.10.22.
//

import Foundation
import CryptoSwift
import secp256k1

public struct Encryptor {
    func makeCryptogram(publicKey: String, privateDetails: PaymentPrivateDetails) throws -> String {
        do {
            let message = try getJSONString(from: privateDetails)
            return try encrypt(message: message, pubKey: publicKey)
        } catch {
            throw error
        }
    }

    func makeCryptogramRSA(publicKey: String, privateDetails: PaymentPrivateDetails) -> String? {
        guard let publicSecKey = createRSAPublicSecKey(from: publicKey) else {
            return nil
        }
        do {
            let message = try getJSONString(from: privateDetails)
            return encryptRSA(message: message, publicKey: publicSecKey)
        } catch {
            return nil
        }
    }

    private func encrypt(message: String, pubKey: String) throws -> String {
        let messageBytes = [UInt8](message.data(using: .utf8) ?? Data())
        let pubKeyBytes = Array(hex: pubKey)

        do {
            let ephemeralPrivateKey = try secp256k1.Signing.PrivateKey(format: .uncompressed)
            let ephemeralPublicKey = [UInt8](ephemeralPrivateKey.publicKey.dataRepresentation)
            let sharedSecret = try derive(pubKey: pubKeyBytes,
                                          ephemeralPrivateKey: [UInt8](ephemeralPrivateKey.dataRepresentation))
            let sharedKeyHash = Hash.sha512(sharedSecret)

            let iv = AES.randomIV(AES.blockSize)
            let aesKey = (sharedKeyHash[0..<32]).bytes
            let macKey = (sharedKeyHash[32..<64]).bytes
            
            let cipherMsg = try aesEncrypt(key: aesKey, iv: iv, message: messageBytes)

            let macGenerator = HMAC(key: macKey, variant: .sha2(.sha256))
            let dataToMac = iv + ephemeralPublicKey + cipherMsg

            let mac = try macGenerator.authenticate(dataToMac)

            let signedMesage = SignedMessage(encryptedMessage: cipherMsg.toBase64(),
                                             ephemeralPublicKey: ephemeralPublicKey.toBase64())


            let signedMessageStr = try getJSONString(from: signedMesage)
            let encrypdedData = EncryptedData(signedMessage: signedMessageStr,
                                              iv: iv.toBase64(),
                                              tag: mac.toBase64())

            let encrMsg = try getJSONString(from: encrypdedData)
            
            return(encrMsg.toBase64())
        } catch {
            throw error
        }
    }
    
    private func derive(pubKey: [UInt8], ephemeralPrivateKey: [UInt8]) throws -> [UInt8] {
        do {
            let publicKey = try secp256k1.Signing.PublicKey(dataRepresentation: pubKey, format: .uncompressed)
            let sharedPoint = try publicKey.multiply(ephemeralPrivateKey, format: .uncompressed)
            return sharedPoint.xonly.bytes
        } catch {
            throw error
        }
    }
    
    private func aesEncrypt(key: [UInt8], iv: [UInt8], message: [UInt8]) throws -> [UInt8] {
        do {
            let cipher = try AES(key: key, blockMode: CBC(iv: iv))
            return try message.encrypt(cipher: cipher)
        } catch {
            throw error
        }
    }

    private func encryptRSA(message: String, publicKey: SecKey) -> String? {
        guard let messageData = message.data(using: .utf8) else {
            return nil
        }
        let algorithm: SecKeyAlgorithm = .rsaEncryptionOAEPSHA256

        guard SecKeyIsAlgorithmSupported(publicKey, .encrypt, algorithm) else {
            return nil
        }

        var error: Unmanaged<CFError>?

        guard let encryptedData = SecKeyCreateEncryptedData(publicKey, algorithm, messageData as CFData, &error) else {
            print("Encryption error: \(error?.takeRetainedValue() as Error? ?? NSError())")
            return nil
        }

        let encryptedBase64String = (encryptedData as Data).base64EncodedString()
        return encryptedBase64String
    }

    private func createRSAPublicSecKey(from base64String: String) -> SecKey? {
        guard let keyData = Data(base64Encoded: base64String) else {
            return nil
        }

        guard let pemString = String(data: keyData, encoding: .utf8) else {
            return nil
        }

       let publicKeyStringWithoutHeaders = pemString
            .replacingOccurrences(of: "-----BEGIN PUBLIC KEY-----", with: "")
            .replacingOccurrences(of: "-----END PUBLIC KEY-----", with: "")

        guard let publicKeyData = Data(base64Encoded: publicKeyStringWithoutHeaders, options: .ignoreUnknownCharacters) else {
            return nil
        }

        let options: [NSString: Any] = [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass: kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits: 2048
        ]
        var error: Unmanaged<CFError>?
        guard let publicKey = SecKeyCreateWithData(publicKeyData as CFData, options as CFDictionary, &error) else {
            print("Failed to create public sec key:", error?.takeRetainedValue() as Error? ?? NSError())
            return nil
        }
        return publicKey
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
}
