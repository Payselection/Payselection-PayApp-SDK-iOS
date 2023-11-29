//
//  MarkQuantity.swift
//
//
//  Created by on 27.11.23.
//

import Foundation

public struct MarkQuantity: Codable {

    public var numerator: Int?
    public var denominator: Int

    public init(numerator: Int? = nil, denominator: Int) {
        self.numerator = numerator
        self.denominator = denominator
    }
}
