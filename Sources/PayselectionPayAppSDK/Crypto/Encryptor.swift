//
//  Encryptor.swift
//  PayselectionPayAppSDK
//
//  Created by Alexander Kogalovsky on 25.10.22.
//

import Foundation
import CryptoSwift
import secp256k1

struct Encryptor {
    
    func makeCryptogram(publicKey: String, privateDetails: PaymentPrivateDetails) throws -> String {
        do {
            let message = try getJSONString(from: privateDetails)
            return try encrypt(pubKey: publicKey, message: message)
        } catch {
            throw error
        }
    }
        
    private func encrypt(pubKey: String, message: String) throws -> String {
        
        let messageBytes = [UInt8](message.data(using: .utf8)!)
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
