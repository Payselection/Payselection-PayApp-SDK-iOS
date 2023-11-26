//
//  UILabel.swift
//  PayselectionPayAppDemo
//
//  Created by  on 21.11.23.
//

import UIKit

extension UILabel {
    func setTitleFont(_ text: String, size: CGFloat = 14, alignment: NSTextAlignment = .left, textColor: UIColor = .black) -> UILabel {
        font = .raleway(.bold, size: size)
        self.textColor = textColor
        textAlignment = alignment
        setupLabel(text, alignment: alignment)
        return self
    }

    func setSubtitleFont(_ text: String, alignment: NSTextAlignment = .left) -> UILabel {
        font = .raleway(.medium, size: 12)
        textColor = .lightBlueDark
        textAlignment = alignment
        setupLabel(text, alignment: alignment)
        return self
    }

    func setSemiFont(_ text: String, size: CGFloat = 16, alignment: NSTextAlignment = .right) -> UILabel {
        font = .raleway(.semiBold, size: size)
        textColor = .black
        textAlignment = alignment
        setupLabel(text, alignment: alignment)
        return self
    }

    private func setupLabel(_ text: String, alignment: NSTextAlignment) {
        isUserInteractionEnabled = false
        numberOfLines = 2
        self.text = text
        self.textAlignment = alignment
    }
}
