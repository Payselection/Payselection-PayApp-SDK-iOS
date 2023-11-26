//
//  UIFont.swift
//  PayselectionPayAppDemo
//
//  Created by  on 16.11.23.
//

import UIKit

extension UIFont {
    enum RalewayFont {
        case regular
        case bold
        case semiBold
        case medium

        var value: String {
            switch self {
            case .regular:
                return "Rawline-Regular"
            case .medium:
                return "RawlineMedium-Regular"
            case .semiBold:
                return "RawlineSemiBold-Regular"
            case .bold:
                return "Rawline-Bold"
            }
        }
    }

    static func raleway(_ type: RalewayFont, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: type.value, size: size) else {
            return .systemFont(ofSize: size)
        }
        return font
    }
}
