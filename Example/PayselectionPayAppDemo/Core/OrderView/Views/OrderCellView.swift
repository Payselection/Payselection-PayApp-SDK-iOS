//
//  OrderCellView.swift
//  PayselectionPayAppDemo
//
//  Created by  on 22.11.23.
//

import UIKit

class OrderCellView: UIView {
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        view.widthAnchor.constraint(equalToConstant: 90).isActive = true
        return view
    }()

    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .line
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()

    init(image: UIImage, title: String, subTitle: String, amount: String) {
        super.init(frame: .zero)
        
        setupViews(image: image, title: title, subTitle: subTitle, amount: amount)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews(image: UIImage, title: String, subTitle: String, amount: String) {
        // view
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 112).isActive = true

        // image
        imageView.image = image
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])

        // line
        addSubview(lineView)
        NSLayoutConstraint.activate([
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1),
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    
        let ganeralStack = UIStackView().setupVertical(16)
        ganeralStack.distribution = .equalCentering
        ganeralStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ganeralStack)
        NSLayoutConstraint.activate([
            ganeralStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            ganeralStack.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -12),
            ganeralStack.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            ganeralStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])

        let textStack = UIStackView().setupVertical(4)
        textStack.addArrangedSubview(UILabel().setTitleFont(title))
        textStack.addArrangedSubview(UILabel().setSubtitleFont(subTitle))
        ganeralStack.addArrangedSubview(textStack)

        let amountStack = UIStackView().setupHorizontal()
        amountStack.translatesAutoresizingMaskIntoConstraints = false
        amountStack.heightAnchor.constraint(equalToConstant: 21).isActive = true
        amountStack.addArrangedSubview(UILabel().setSemiFont(amount))
        let trashIcon = UIImageView(image: .trashIcon)
        trashIcon.contentMode = .center
        amountStack.addArrangedSubview(trashIcon)
        ganeralStack.addArrangedSubview(amountStack)
    }
}
