//
//  PaymentCardFrame.swift
//  PayselectionPayAppDemo
//
//  Created by  on 16.11.23.
//

import UIKit

class PaymentCardFrame: UIView {
    // MARK: - Const
    struct CON {
        static let addCardTitle = NSLocalizedString("Добавить карту", comment: "")
        static let padding: CGFloat = 8.0
    }

    // MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .raleway(.semiBold, size: 10)
        label.textAlignment = .left
        label.textColor = .lightBlueDark
        label.text = CON.addCardTitle
        return label
    }()

    private let statusImageView: UIImageView = {
        let view = UIImageView(image: .statusAdd)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .lightBlueDark
        view.isUserInteractionEnabled = false
        view.heightAnchor.constraint(equalToConstant: 12).isActive = true
        return view
    }()

    private let logoFrameImageView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.layer.cornerRadius = 3
        view.backgroundColor = .borderGray
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        view.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return view
    }()

    private let logoImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .center
        return view
    }()

    private var numberCard: String? {
        didSet {
            titleLabel.text = numberCard
            titleLabel.font = .raleway(.semiBold, size: numberCard == nil ? 10 : 12)
            statusImageView.image = numberCard == nil ? .statusAdd : .statusDone
        }
    }

    var selected: Bool {
        didSet {
            statusImageView.tintColor = selected ? (numberCard == nil ? .blue : .white) : .lightBlueDark
            layer.borderColor = selected ? UIColor.blue.cgColor : UIColor.lightBlueDark.cgColor
            // empty card
            if numberCard == nil {
                titleLabel.textColor = selected ? .black : .lightBlueDark
                backgroundColor = .white
            // card with data
            } else {
                titleLabel.textColor = selected ? .white : .lightBlueDark
                backgroundColor = selected ? .blue : .white
            }
        }
    }

    private var logoImageName: String? {
        didSet {
            logoFrameImageView.isHidden = logoImageName == nil
            logoImageView.image = logoImageName != nil ? UIImage(named: logoImageName!) : nil
        }
    }

    var cardModel: PaymentCardModel? {
        didSet {
            guard let cardModel else { return }
            numberCard = "**" + String(cardModel.cardNumber.suffix(4))
            logoImageName = cardModel.typeLogoName
        }
    }

    override init(frame: CGRect) {
        selected = false
    
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        layer.cornerRadius = CON.padding
        layer.borderColor = UIColor.borderGray.cgColor
        layer.borderWidth = 1

        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -CON.padding),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CON.padding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: CON.padding)
        ])

        addSubview(statusImageView)
        NSLayoutConstraint.activate([
            statusImageView.topAnchor.constraint(equalTo: topAnchor, constant: CON.padding),
            statusImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -CON.padding)
        ])

        addSubview(logoFrameImageView)
        NSLayoutConstraint.activate([
            logoFrameImageView.topAnchor.constraint(equalTo: topAnchor, constant: CON.padding),
            logoFrameImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CON.padding)
        ])
        logoFrameImageView.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: logoFrameImageView.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: logoFrameImageView.centerYAnchor)
        ])
    }
}
