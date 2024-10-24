//
//  StatusResponse.swift
//  PayselectionPayAppSDK
//
//  Created by Alexander Kogalovsky on 1.11.22.
//

import Foundation

public struct StatusResult: Codable {
    public var transactionState: TransactionState
    public var transactionId: String
    public var orderId: String
    public var stateDetails: StateDetails

    enum CodingKeys: String, CodingKey {
        case transactionState = "TransactionState"
        case transactionId = "TransactionId"
        case orderId = "OrderId"
        case stateDetails = "StateDetails"
    }
}

public struct StatusResult3ds: Codable {
    public var transactionState: TransactionState
    public var transactionId: String
    public var orderId: String
    public var stateDetails3ds: StateDetails3ds

    enum CodingKeys: String, CodingKey {
        case transactionState = "TransactionState"
        case transactionId = "TransactionId"
        case orderId = "OrderId"
        case stateDetails3ds = "StateDetails"
    }
}

public struct StateDetails: Codable {
    public var amount: String?
    public var currency: String?
    public var processingAmount: String?
    public var cryptoAmount: String?
    public var cryptoName: String?
    public var processingCurrency: String?
    public var remainingAmount: String?
    public var rebillId: String?
    
    public var acsUrl: String?
    public var paReq: String?
    public var md: String?
    
    public var code: String?
    public var description: String?
    
    public var redirectUrl: String?
    public var redirectMethod: String?
    
    enum CodingKeys: String, CodingKey {
        case amount = "Amount"
        case currency = "Currency"
        case processingAmount = "ProcessingAmount"
        case cryptoAmount = "CryptoAmount"
        case cryptoName = "CryptoName"
        case processingCurrency = "ProcessingCurrency"
        case remainingAmount = "RemainingAmount"
        case rebillId = "RebillId"
        
        case acsUrl = "AcsUrl"
        case paReq = "PaReq"
        case md = "MD"
        
        case code = "Code"
        case description = "Description"
        
        case redirectUrl = "RedirectUrl"
        case redirectMethod = "RedirectMethod"
    }
}

public struct StateDetails3ds: Codable {
    public var acsUrl: String
    public var paRes: String
    public var md: String
    
    enum CodingKeys: String, CodingKey {
        case acsUrl = "AcsUrl"
        case paRes = "PaRes"
        case md = "MD"
    }
}

public enum TransactionState: String, Codable {
    case success
    case preauthorized
    case pending
    case voided
    case declined
    case waitFor3ds = "wait_for_3ds"
    case redirect
    case unknown 
    
    public init(from decoder: Decoder) throws {
        guard let value = try? decoder.singleValueContainer().decode(String.self) else {
            self = .unknown
            return
        }
        self = TransactionState(rawValue: value) ?? .unknown
    }
}



