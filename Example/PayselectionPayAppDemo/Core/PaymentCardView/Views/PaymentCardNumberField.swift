//
//  PaymentCardNumberField.swift
//  PayselectionPayAppDemo
//
//  Created by  on 17.11.23.
//

import UIKit

class PaymentCardNumberField: UIView {
    // MARK: - Const
    struct CON {
        static let fieldTitle = NSLocalizedString("Номер карты", comment: "")
        static let fieldErrorTitle = NSLocalizedString("Некорректный номер карты", comment: "")
        static let widthButton: CGFloat = 57.0
        static let paddingField: CGFloat = 8.0
        static let paddingLeadField: CGFloat = 16.0
        static let placeholderFontActive: UIFont = .raleway(.medium, size: 18)
        static let placeholderFontNotActive: UIFont = .raleway(.medium, size: 12)
    }

    private let vLine: UIView = {
        let view = UIView()
        view.isHidden = true
        view.layer.cornerRadius = 0.5
        view.backgroundColor = .borderGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()

    private lazy var dismissButton: UIButton = {
        let button = UIButton(type: .custom)
        button.isHidden = true
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        button.setImage(.buttonClose, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: CON.widthButton).isActive = true
        return button
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .raleway(.bold, size: 18)
        textField.returnKeyType = .done
        textField.textColor = .black
        textField.placeholder = .none
        textField.borderStyle = .none
        textField.keyboardType = .numberPad
        textField.delegate = self
        textField.addTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)
        return textField
    }()

    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = CON.placeholderFontActive
        label.textAlignment = .left
        label.text = CON.fieldTitle
        label.textColor = .lightBlueDark
        return label
    }()

    private var placeholderCenterConstr: NSLayoutConstraint?
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?

    private(set) var isValidated: Bool = false
    private(set) var cardNumber: String?
    private(set) var isInvalide: Bool = false {
        didSet {
            setupErrorField(isError: isInvalide)
            setupDismissButton()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        layer.cornerRadius = 8
        layer.borderColor = UIColor.borderGray.cgColor
        layer.borderWidth = 1

        addSubview(vLine)
        NSLayoutConstraint.activate([
            vLine.topAnchor.constraint(equalTo: topAnchor, constant: CON.paddingField),
            vLine.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -CON.paddingField),
            vLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -CON.widthButton - 1)
        ])

        addSubview(dismissButton)
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: topAnchor),
            dismissButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            dismissButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -CON.paddingField),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CON.paddingLeadField),
            textField.trailingAnchor.constraint(equalTo: vLine.leadingAnchor, constant: -CON.paddingField)
        ])

        addSubview(placeholderLabel)
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: CON.paddingField),
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CON.paddingLeadField)
        ])
        placeholderCenterConstr = placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        placeholderCenterConstr?.isActive = true
    }

    func setupNumberCard(_ number: String?) {
        textField.text = number
        reformatAsCardNumber(textField: textField)
        textFieldDidChangeSelection(textField)
        if number == nil {
            textFieldDidEndEditing(textField)
        } else {
            textFieldDidBeginEditing(textField)
        }
    }

    private func setupErrorField(isError: Bool) {
        layer.borderColor = isError ? UIColor.error.cgColor : UIColor.borderGray.cgColor
        placeholderLabel.textColor = isError ? .error : .lightBlueDark
        placeholderLabel.text = isError ? CON.fieldErrorTitle : CON.fieldTitle
        textField.textColor = isError ? .error : .black
        dismissButton.isUserInteractionEnabled = isError
    }

    private func setupDismissButton() {
        vLine.isHidden = true
        dismissButton.isHidden = true

        var image: UIImage? = nil
        if let cardNumber, let imageName = PaymentCardModel.logoNameByType(PaymentCardModel.typeByPrefix(String(cardNumber.prefix(1)))), !isInvalide {
            image = UIImage(named: imageName)
            vLine.isHidden = false
            dismissButton.isHidden = false
        }
        dismissButton.setImage(image, for: .normal)
    }

    @objc private func reformatAsCardNumber(textField: UITextField) {
        var targetCursorPosition = 0
        if let startPosition = textField.selectedTextRange?.start {
            targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
        }

        var cardNumberWithoutSpaces = ""
        if let text = textField.text {
            cardNumberWithoutSpaces = self.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
        }
        isInvalide = false
        if cardNumberWithoutSpaces.count > PaymentCardModel.cardCharacterCount {
            textField.text = previousTextFieldContent
            textField.selectedTextRange = previousSelection
            if let previousTextFieldContent {
                isInvalide = !PaymentCardModel.validateCardNumber(previousTextFieldContent)
            }
            return
        } else if cardNumberWithoutSpaces.count == PaymentCardModel.cardCharacterCount {
            isInvalide = !PaymentCardModel.validateCardNumber(cardNumberWithoutSpaces)
        }

        let cardNumberWithSpaces = self.insertSpacesEveryFourDigitsIntoString(string: cardNumberWithoutSpaces, andPreserveCursorPosition: &targetCursorPosition)
        textField.text = cardNumberWithSpaces

        if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
            textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
        }
    }

    private func removeNonDigits(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var digitsOnlyString = ""
        let originalCursorPosition = cursorPosition
        
        for i in Swift.stride(from: 0, to: string.count, by: 1) {
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            if characterToAdd >= "0" && characterToAdd <= "9" {
                digitsOnlyString.append(characterToAdd)
            }
            else if i < originalCursorPosition {
                cursorPosition -= 1
            }
        }
        return digitsOnlyString
    }

    private func insertSpacesEveryFourDigitsIntoString(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var stringWithAddedSpaces = ""
        let cursorPositionInSpacelessString = cursorPosition
        for i in Swift.stride(from: 0, to: string.count, by: 1) {
            if i > 0 && (i % 4) == 0 {
                stringWithAddedSpaces.append(contentsOf: " ")
                if i < cursorPositionInSpacelessString {
                    cursorPosition += 1
                }
            }
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            stringWithAddedSpaces.append(characterToAdd)
        }
        return stringWithAddedSpaces
    }
}

extension PaymentCardNumberField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        placeholderCenterConstr?.isActive = false
        placeholderLabel.font = CON.placeholderFontNotActive
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else {
            placeholderCenterConstr?.isActive = true
            placeholderLabel.font = CON.placeholderFontActive
            return
        }
        isInvalide = !PaymentCardModel.validateCardNumber(text)
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        let cardNumberString = textField.text != nil ? textField.text!.replacingOccurrences(of: " ", with: "") : ""
        isValidated = PaymentCardModel.validateCardNumber(cardNumberString)
        cardNumber = cardNumberString
        setupDismissButton()

        NotificationCenter.default.post(name: .fieldsChanged, object: nil, userInfo: nil)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        previousTextFieldContent = textField.text
        previousSelection = textField.selectedTextRange
        return true
    }
}
