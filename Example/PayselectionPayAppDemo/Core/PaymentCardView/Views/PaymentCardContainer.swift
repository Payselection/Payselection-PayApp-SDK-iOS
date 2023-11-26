//
//  PaymentCardContainer.swift
//  PayselectionPayAppDemo
//
//  Created by  on 16.11.23.
//

import UIKit

class PaymentCardContainer: UIStackView {
    // MARK: - Const
    struct CON {
        static let saveButtonTitle = NSLocalizedString("Сохранить карту", comment: "")
        static let payButtonTitle = NSLocalizedString("Оплатить картой", comment: "")
        static let heightField: CGFloat = 57.0
        static let stackSpacing: CGFloat = 16.0
        static let cardsSpacing: CGFloat = 8.0
        static let heightButton: CGFloat = 46.0
        static let cornerRadius: CGFloat = 8.0
    }

    // MARK: - UI
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.heightAnchor.constraint(equalToConstant: CON.heightField).isActive = true
        return scrollView
    }()

    private var cardsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .horizontal
        stackView.spacing = CON.cardsSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var dateAndCvvStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = CON.cardsSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var numberCardField: PaymentCardNumberField = {
        let view = PaymentCardNumberField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: CON.heightField).isActive = true
        return view
    }()

    private var dateCardField: PaymentCardDateField = {
        let view = PaymentCardDateField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: CON.heightField).isActive = true
        return view
    }()

    private var cvvCardField: PaymentCardCvvField = {
        let view = PaymentCardCvvField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: CON.heightField).isActive = true
        return view
    }()

    private var viewPadding: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.isUserInteractionEnabled = false
        button.setTitle(CON.saveButtonTitle, for: .normal)
        button.backgroundColor = .lightBlue
        button.layer.cornerRadius = CON.cornerRadius
        button.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: CON.heightButton).isActive = true
        return button
    }()

    private var observer: NSObjectProtocol?
    private var selectedCard: PaymentCardFrame?

    var handlerSaveCard: ((PaymentCardModel) -> Void)?
    var handlerPayByCard: ((PaymentCardModel) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        spacing = CON.stackSpacing

        // cards views
        scrollView.addSubview(cardsStackView)
        addArrangedSubview(scrollView)

        // number card
        addArrangedSubview(numberCardField)

        // number card
        dateAndCvvStackView.addArrangedSubview(dateCardField)
        dateAndCvvStackView.addArrangedSubview(cvvCardField)
        addArrangedSubview(dateAndCvvStackView)

        // save button
        addArrangedSubview(viewPadding)
        addArrangedSubview(saveButton)

        // observer for save card
        observer = NotificationCenter.default.addObserver(forName: .fieldsChanged, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.updateSaveButton()
        }
    }

    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer, name: .fieldsChanged, object: nil)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // setup contentSize for cards
        scrollView.contentSize = cardsStackView.frame.size
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func unselectAllCard() {
        for item in cardsStackView.subviews {
            if let card = item as? PaymentCardFrame {
                card.selected = false
            }
        }
    }

    private func updateSaveButton() {
        let isValidated = self.numberCardField.isValidated && self.dateCardField.isValidated && self.cvvCardField.isValidated
        saveButton.backgroundColor = isValidated ? .blue : .lightBlue
        saveButton.isUserInteractionEnabled = isValidated
    }

    private func setupSelectedContainer(_ view: PaymentCardFrame, selected: Bool = true, isNew: Bool = false) {
        unselectAllCard()
        view.selected = selected
        selectedCard = view
        saveButton.setTitle(view.cardModel == nil ? CON.saveButtonTitle : CON.payButtonTitle, for: .normal)
        numberCardField.setupNumberCard(view.cardModel?.cardNumber)
        dateCardField.setupDate(cardExpMonth: view.cardModel?.cardExpMonth, cardExpYear: view.cardModel?.cardExpYear)
        cvvCardField.setSecureText()
        updateSaveButton()

        guard !isNew else { return }
        cvvCardField.clearField()
    }

    func addCard(_ model: PaymentCardModel? = nil, isNew: Bool = false) {
        let card = PaymentCardFrame()
        card.cardModel = model
        card.translatesAutoresizingMaskIntoConstraints = false
        card.heightAnchor.constraint(equalToConstant: CON.heightField).isActive = true
        card.widthAnchor.constraint(equalToConstant: self.frame.width / 3.0 - 6).isActive = true
        cardsStackView.insertArrangedSubview(card, at: 0)
        card.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cardTap(_:))))
        setupSelectedContainer(card, selected: model != nil, isNew: isNew)
        // scroll to this card
        if model != nil {
            scrollView.setContentOffset(.zero, animated: true)
        }
        // setup contentSize for cards
        layoutIfNeeded()
        setNeedsLayout()
    }

    @objc private func cardTap(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view as? PaymentCardFrame else { return }
        setupSelectedContainer(view)
        endEditing(true)
    }

    @objc private func handleSaveButton() {
        guard let cardNumber = numberCardField.cardNumber, let cardExpYear = dateCardField.cardExpYear, let cardExpMonth = dateCardField.cardExpMonth, let cvcNumber = cvvCardField.cvcNumber else { return }

        let payment = PaymentCardModel(id: selectedCard?.cardModel?.id ?? UUID().uuidString,
                                       cardNumber: cardNumber,
                                       cardExpMonth: String(cardExpMonth),
                                       cardExpYear: String(cardExpYear),
                                       cvc: cvcNumber)
        // handlers
        if selectedCard?.cardModel == nil {
            handlerSaveCard?(payment)
        } else {
            handlerPayByCard?(payment)
            // update card data
            selectedCard?.cardModel = payment
        }

        endEditing(true)
    }
}
