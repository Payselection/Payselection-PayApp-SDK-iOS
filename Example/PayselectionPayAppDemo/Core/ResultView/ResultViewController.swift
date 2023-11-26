//
//  ResultViewController.swift
//  PayselectionPayAppDemo
//
//  Created by  on 21.11.23.
//

import UIKit

class ResultViewController: UIViewController {
    // MARK: - Const
    struct MOC {
        static let titleText: String = "Заказ №31\nуспешно оплачен"

        static let infoTitleText: String = "Информация о заказе"
        static let infoNumberText: String = "Заказ №31"
        static let infoDateText: String = "12.09.2023 10:30"

        static let recipTitleText: String = "Получатель"
        static let recipNumberText: String = "Гарик Кравцов"
        static let recipDateText: String = "+7 910 000-00-00"

        static let deliveryTitleText: String = "Курьерская доставка"
        static let deliveryAdressText: String = "Россия, г. Москва, ул. Цветной бульвар, д. 30, стр. 1"

        static let paidTitleText: String = "Оплачено"
        static let paidCardText: String = "Картой онлайн "
        static let paidAmountText: String = "Стоимость"
        static let paidDeliveryText: String = "Доставка"
        static let paidTaxText: String = "НДС"
        static let paidDiscountText: String = "Скидка"
        static let paidTotalText: String = "Итого"
    }

    struct CON {
        static let closeButtonTitle: String = NSLocalizedString("На главную", comment: "")
        static let cornerRadius: CGFloat = 8.0
        static let heightButton: CGFloat = 46.0
        
        static let paddingView: CGFloat = 24.0
        static let bottomPaddingView: CGFloat = 34.0
    }

    //MARK: - UI
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(CON.closeButtonTitle, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = CON.cornerRadius
        button.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: CON.heightButton).isActive = true
        return button
    }()

    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .white
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 40
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let cardNumber: String

    init(cardNumber: String) {
        self.cardNumber = cardNumber

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -CON.bottomPaddingView),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CON.paddingView),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -CON.paddingView)
        ])

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CON.paddingView),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -CON.paddingView)
        ])
        stackView.addArrangedSubview(UILabel().setTitleFont(MOC.titleText, size: 24, alignment: .center))

        let ganeralStack = UIStackView().setupVertical(16)
        stackView.addArrangedSubview(ganeralStack)

        let infoStack = UIStackView().setupVertical(8)
        infoStack.addArrangedSubview(UILabel().setTitleFont(MOC.infoTitleText))
        let infoLinesStack = UIStackView().setupVertical(6)
        infoLinesStack.addArrangedSubview(UILabel().setSubtitleFont(MOC.infoNumberText))
        infoLinesStack.addArrangedSubview(UILabel().setSubtitleFont(MOC.infoDateText))
        infoStack.addArrangedSubview(infoLinesStack)
        ganeralStack.addArrangedSubview(infoStack)

        let recipStack = UIStackView().setupVertical(8)
        recipStack.addArrangedSubview(UILabel().setTitleFont(MOC.recipTitleText))
        let recipLineStack = UIStackView().setupVertical(6)
        recipLineStack.addArrangedSubview(UILabel().setSubtitleFont(MOC.recipNumberText))
        recipLineStack.addArrangedSubview(UILabel().setSubtitleFont(MOC.recipDateText))
        recipStack.addArrangedSubview(recipLineStack)
        ganeralStack.addArrangedSubview(recipStack)

        let deliveryStack = UIStackView().setupVertical(8)
        deliveryStack.addArrangedSubview(UILabel().setTitleFont(MOC.deliveryTitleText))
        deliveryStack.addArrangedSubview(UILabel().setSubtitleFont(MOC.deliveryAdressText))
        ganeralStack.addArrangedSubview(deliveryStack)

        let paidStack = UIStackView().setupVertical(8)
        paidStack.addArrangedSubview(UILabel().setTitleFont(MOC.paidTitleText))
        let paidLineStack = UIStackView().setupVertical(6)
        // title
        let cardType = PaymentCardModel.typeNameCardByNumber(cardNumber) ?? ""
        let cardText = "\(MOC.paidCardText)\(cardType) ****\(String(cardNumber.suffix(4)))"
        paidLineStack.addArrangedSubview(UILabel().setSubtitleFont(cardText))
        // Card
        let paidCardStack = UIStackView().setupHorizontal()
        paidCardStack.addArrangedSubview(UILabel().setSubtitleFont(MOC.paidAmountText))
        paidCardStack.addArrangedSubview(UILabel().setSubtitleFont("297 ₽", alignment: .right))
        paidLineStack.addArrangedSubview(paidCardStack)
        // Amount
        let paidAmountStack = UIStackView().setupHorizontal()
        paidAmountStack.addArrangedSubview(UILabel().setSubtitleFont(MOC.paidDeliveryText))
        paidAmountStack.addArrangedSubview(UILabel().setSubtitleFont("149 ₽", alignment: .right))
        paidLineStack.addArrangedSubview(paidAmountStack)
        // Tax
        let paidTaxStack = UIStackView().setupHorizontal()
        paidTaxStack.addArrangedSubview(UILabel().setSubtitleFont(MOC.paidDeliveryText))
        paidTaxStack.addArrangedSubview(UILabel().setSubtitleFont("0 ₽", alignment: .right))
        paidLineStack.addArrangedSubview(paidTaxStack)
        // Discount
        let paidDiscountStack = UIStackView().setupHorizontal()
        paidDiscountStack.addArrangedSubview(UILabel().setSubtitleFont(MOC.paidDiscountText))
        paidDiscountStack.addArrangedSubview(UILabel().setSubtitleFont("0 ₽", alignment: .right))
        paidLineStack.addArrangedSubview(paidDiscountStack)
        // Total
        let paidTotalStack = UIStackView().setupHorizontal()
        paidTotalStack.addArrangedSubview(UILabel().setSubtitleFont(MOC.paidTotalText))
        paidTotalStack.addArrangedSubview(UILabel().setSubtitleFont("446 ₽", alignment: .right))
        paidLineStack.addArrangedSubview(paidTotalStack)

        paidStack.addArrangedSubview(paidLineStack)
        ganeralStack.addArrangedSubview(paidStack)
    }

    @objc private func handleCloseButton() {
        NotificationCenter.default.post(name: .dismissPayment, object: nil, userInfo: nil)
        dismiss(animated: true)
    }
}
