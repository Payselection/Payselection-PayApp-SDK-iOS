//
//  OrderViewController.swift
//  PayselectionPayAppDemo
//
//  Created by  on 21.11.23.
//

import UIKit

class OrderViewController: UIViewController {
    // MARK: - Const
    struct MOC {
        static let titleText: String = "Оформление заказа №31"

        static let whiteTitleText: String = "Белый пончик"
        static let whiteText: String = "Металл, 13 см"

        static let blackTitleText: String = "Черная сфера"
        static let blackText: String = "Гранит, 10 см"

        static let cubeTitleText: String = "Стеклянный куб"
        static let cubeText: String = "Стекло, 20 см"

        static let paidAmountText: String = "Стоимость"
        static let paidDeliveryText: String = "Доставка"
        static let paidTaxText: String = "НДС"
        static let paidDiscountText: String = "Скидка"
        static let paidTotalText: String = "Итого"
    }

    struct CON {
        static let closeButtonTitle: String = NSLocalizedString("Оплатить", comment: "")
        static let cornerRadius: CGFloat = 8.0
        static let heightButton: CGFloat = 46.0
        static let heightEmptyTopView: CGFloat = 50.0
        static let paddingView: CGFloat = 24.0
        static let bottomPaddingView: CGFloat = 34.0
    }

    //MARK: - UI
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: CON.heightEmptyTopView).isActive = true
        return view
    }()

    private var footerButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: CON.paddingView / 2.0).isActive = true
        return view
    }()
    private var footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: CON.heightEmptyTopView).isActive = true
        return view
    }()

    private lazy var payButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(CON.closeButtonTitle, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = CON.cornerRadius
        button.addTarget(self, action: #selector(handlePayButton), for: .touchUpInside)
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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(payButton)
        NSLayoutConstraint.activate([
            payButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -CON.bottomPaddingView),
            payButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CON.paddingView),
            payButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -CON.paddingView)
        ])

        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: payButton.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CON.paddingView),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -CON.paddingView)
        ])
        scrollView.addSubview(stackView)
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        // empty view
        stackView.addArrangedSubview(headerView)
        // title
        stackView.addArrangedSubview(UILabel().setSemiFont(MOC.titleText, alignment: .center))
        // cells
        let cellStack = UIStackView().setupVertical(12)
        cellStack.addArrangedSubview(OrderCellView(image: .imageWhite, title: MOC.whiteTitleText, subTitle: MOC.whiteText, amount: "99 ₽"))
        cellStack.addArrangedSubview(OrderCellView(image: .imageBlack, title: MOC.blackTitleText, subTitle: MOC.blackText, amount: "49 ₽"))
        cellStack.addArrangedSubview(OrderCellView(image: .imageGlass, title: MOC.cubeTitleText, subTitle: MOC.cubeText, amount: "149 ₽"))
        stackView.addArrangedSubview(cellStack)
        
        // total lines
        let totalGeneralStack = UIStackView().setupVertical(24)
        stackView.addArrangedSubview(totalGeneralStack)

        let totalStack = UIStackView().setupVertical(8)
        // 1.
        let amountStack = UIStackView().setupHorizontal()
        amountStack.addArrangedSubview(UILabel().setTitleFont(MOC.paidAmountText, textColor: .lightBlueDark))
        amountStack.addArrangedSubview(UILabel().setTitleFont("297 ₽", alignment: .right, textColor: .lightBlueDark))
        totalStack.addArrangedSubview(amountStack)
        // 2.
        let deliveryStack = UIStackView().setupHorizontal()
        deliveryStack.addArrangedSubview(UILabel().setTitleFont(MOC.paidDeliveryText, textColor: .lightBlueDark))
        deliveryStack.addArrangedSubview(UILabel().setTitleFont("149 ₽", alignment: .right, textColor: .lightBlueDark))
        totalStack.addArrangedSubview(deliveryStack)
        // 3.
        let taxStack = UIStackView().setupHorizontal()
        taxStack.addArrangedSubview(UILabel().setTitleFont(MOC.paidTaxText, textColor: .lightBlueDark))
        taxStack.addArrangedSubview(UILabel().setTitleFont("0 ₽", alignment: .right, textColor: .lightBlueDark))
        totalStack.addArrangedSubview(taxStack)
        // 4.
        let discountStack = UIStackView().setupHorizontal()
        discountStack.addArrangedSubview(UILabel().setTitleFont(MOC.paidDiscountText, textColor: .lightBlueDark))
        discountStack.addArrangedSubview(UILabel().setTitleFont("0 ₽", alignment: .right, textColor: .lightBlueDark))
        totalStack.addArrangedSubview(discountStack)
        totalGeneralStack.addArrangedSubview(totalStack)

        // total
        let amountTotalStack = UIStackView().setupHorizontal()
        amountTotalStack.addArrangedSubview(UILabel().setTitleFont(MOC.paidTotalText, size: 24))
        amountTotalStack.addArrangedSubview(UILabel().setTitleFont("446 ₽", size: 24, alignment: .right))
        totalGeneralStack.addArrangedSubview(amountTotalStack)
        totalGeneralStack.addArrangedSubview(footerView)

        view.addSubview(footerButtonView)
        NSLayoutConstraint.activate([
            footerButtonView.bottomAnchor.constraint(equalTo: payButton.topAnchor),
            footerButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CON.paddingView),
            footerButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -CON.paddingView)
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = stackView.frame.size
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)
        scrollView.setContentOffset(bottomOffset, animated: false)
    }

    @objc private func handlePayButton() {
        self.present(by: .payment)
    }
}
