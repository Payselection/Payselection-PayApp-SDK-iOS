//
//  MerchantCredentials.swift
//  PayselectionPayAppSDK
//
//  Created by Alexander Kogalovsky on 2.11.22.
//

import Foundation

public struct MerchantCredentials {
    public var merchantId: String
    public var publicKey: String
    public var publicRSAKey: String
    public var networkConfig: NetworkConfig
    
    public init(merchantId: String,
                publicKey: String,
                publicRSAKey: String,
                networkConfig: NetworkConfig? = nil) {
        self.merchantId = merchantId
        self.publicKey = publicKey
        self.publicRSAKey = publicRSAKey
        self.networkConfig = networkConfig ?? NetworkConfig()
    }
}
