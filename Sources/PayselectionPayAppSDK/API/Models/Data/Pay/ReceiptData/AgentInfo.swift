//
//  AgentInfo.swift
//  
//
//  Created by Alexander Kogalovsky on 20.09.23.
//

import Foundation

public struct AgentInfo: Codable {
    
    public var type: String?
    public var payingAgent: PayingAgent?
    public var receivePaymentsOperator: ReceivePaymentsOperator?
    public var moneyTransferOperator: MoneyTransferOperator?
    
    enum CodingKeys: String, CodingKey {
        case type
        case payingAgent = "paying_agent"
        case receivePaymentsOperator = "receive_payments_operator"
        case moneyTransferOperator = "money_transfer_operator"
    }
    
    public init(type: String? = nil,
                payingAgent: PayingAgent? = nil,
                receivePaymentsOperator: ReceivePaymentsOperator? = nil,
                moneyTransferOperator: MoneyTransferOperator? = nil) {
        self.type = type
        self.payingAgent = payingAgent
        self.receivePaymentsOperator = receivePaymentsOperator
        self.moneyTransferOperator = moneyTransferOperator
    }
}

public struct PayingAgent: Codable {
    
    public var operation: String?
    public var phones: [String]?
    
    public init(operation: String? = nil,
                phones: [String]? = nil) {
        self.operation = operation
        self.phones = phones
    }
}

public struct ReceivePaymentsOperator: Codable {

    public var phones: [String]?

    public init(phones: [String]? = nil) {
        self.phones = phones
    }
}

public struct MoneyTransferOperator: Codable {
    
    public var phones: [String]?
    public var name: String?
    public var address: String?
    public var inn: String?
    
    public init(phones: [String]? = nil,
                name: String? = nil,
                address: String? = nil,
                inn: String? = nil) {
        self.phones = phones
        self.name = name
        self.address = address
        self.inn = inn
    }
}

