//
//  UIStackView.swift
//  PayselectionPayAppDemo
//
//  Created by  on 21.11.23.
//

import UIKit

extension UIStackView {
    func setupVertical(_ spacing: CGFloat, alignment: Alignment = .fill) -> UIStackView {
        axis = .vertical
        self.alignment = alignment
        self.spacing = spacing
        return self
    }

    func setupHorizontal(_ spacing: CGFloat = 0, alignment: Alignment = .fill) -> UIStackView {
        axis = .horizontal
        self.distribution = .equalSpacing
        self.alignment = alignment
        self.spacing = spacing
        return self
    }
}
