//
//  MerchantCredentials.swift
//  PayselectionPayAppSDK
//
//  Created by Aliaksei Gorodji on 18.05.23.
//

import Foundation

public struct NetworkConfig {
    public var serverUrl: String
    
    public init(serverUrl: String? = nil) {
        self.serverUrl = serverUrl ?? "https://pgw.payselection.com"
    }
}
