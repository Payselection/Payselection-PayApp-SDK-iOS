//
//  ExtraData.swift
//  Payselection-PayApp-SDK
//
//  Created by Alexander Kogalovsky on 7.11.22.
//

import Foundation

public struct ExtraData: Codable {
    var returnUrl: String?
    var webhookUrl: String?
    var screenHeight: String?
    var screenWidth: String?
    var challengeWindowSize: String?
    var timeZoneOffset: String?
    var colorDepth: String?
    var region: String?
    var userAgent: String?
    var acceptHeader: String?
    var javaEnabled: Bool?
    var javaScriptEnabled: Bool?

    enum CodingKeys: String, CodingKey {
        case returnUrl = "ReturnUrl"
        case webhookUrl = "WebhookUrl"
        case screenHeight = "ScreenHeight"
        case screenWidth = "ScreenWidth"
        case challengeWindowSize = "ChallengeWindowSize"
        case timeZoneOffset = "TimeZoneOffset"
        case colorDepth = "ColorDepth"
        case region = "Region"
        case userAgent = "UserAgent"
        case acceptHeader = "acceptHeader"
        case javaEnabled = "JavaEnabled"
        case javaScriptEnabled = "javaScriptEnabled"
    }

    public init(returnUrl: String? = nil,
                webhookUrl: String? = nil,
                screenHeight: String? = nil,
                screenWidth: String? = nil,
                challengeWindowSize: String? = nil,
                timeZoneOffset: String? = nil,
                colorDepth: String? = nil,
                region: String? = nil,
                userAgent: String? = nil,
                acceptHeader: String? = nil,
                javaEnabled: Bool? = nil,
                javaScriptEnabled: Bool? = nil) {
        self.returnUrl = returnUrl
        self.webhookUrl = webhookUrl
        self.screenHeight = screenHeight
        self.screenWidth = screenWidth
        self.challengeWindowSize = challengeWindowSize
        self.timeZoneOffset = timeZoneOffset
        self.colorDepth = colorDepth
        self.region = region
        self.userAgent = userAgent
        self.acceptHeader = acceptHeader
        self.javaEnabled = javaEnabled
        self.javaScriptEnabled = javaScriptEnabled
    }
}
