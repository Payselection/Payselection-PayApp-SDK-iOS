//
//  MarkCode.swift
//
//
//  Created by on 27.11.23.
//

import Foundation

public struct MarkCode: Codable {

    public var unknown: String?
    public var ean: String?
    public var ean13: String?
    public var itf14: String?
    public var gs10: String?
    public var gs1m: String?
    public var short: String?
    public var fur: String?
    public var egais20: String?
    public var egais30: String?

    public init(unknown: String? = nil, ean: String? = nil, ean13: String? = nil, itf14: String? = nil, gs10: String? = nil, gs1m: String? = nil, short: String? = nil, fur: String? = nil, egais20: String? = nil, egais30: String? = nil) {
        self.unknown = unknown
        self.ean = ean
        self.ean13 = ean13
        self.itf14 = itf14
        self.gs10 = gs10
        self.gs1m = gs1m
        self.short = short
        self.fur = fur
        self.egais20 = egais20
        self.egais30 = egais30
    }
}
