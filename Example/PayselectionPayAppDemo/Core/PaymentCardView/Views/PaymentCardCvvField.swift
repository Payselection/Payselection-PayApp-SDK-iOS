//
//  PaymentCardCvvField.swift
//  PayselectionPayAppDemo
//
//  Created by  on 17.11.23.
//

import UIKit

class PaymentCardCvvField: UIView {
    // MARK: - Const
    struct CON {
        static let fieldTitle = NSLocalizedString("CVV", comment: "")
        static let fieldErrorTitle = NSLocalizedString("Ошибка CVV", comment: "")
        static let widthButton: CGFloat = 57.0
        static let paddingField: CGFloat = 8.0
        static let paddingLeadField: CGFloat = 16.0
        static let placeholderFontActive: UIFont = .raleway(.medium, size: 18)
        static let placeholderFontNotActive: UIFont = .raleway(.medium, size: 12)
        static let cvvCount: Int = 3
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
        button.setImage(.cvvEye, for: .normal)
        button.addTarget(self, action: #selector(handleDismissButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: CON.widthButton).isActive = true
        return button
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .raleway(.bold, size: 18)
        textField.returnKeyType = .done
        textField.delegate = self
        textField.textColor = .black
        textField.placeholder = .none
        textField.borderStyle = .none
        textField.keyboardType = .numberPad
        textField.isSecureTextEntry = true
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
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

    private(set) var isValidated: Bool = false
    private(set) var cvcNumber: String?
    private(set) var isInvalide: Bool = false {
        didSet {
            setupErrorField(isError: isInvalide)
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

    func clearField() {
        textField.text = nil
        setupDismissButton(empty: true)
        textFieldDidChangeSelection(textField)
        textFieldDidEndEditing(textField)
    }

    func setSecureText() {
        setupDismissButton(empty: (textField.text != nil) ? textField.text!.isEmpty : true)
        textField.isSecureTextEntry = true
    }

    @objc private func handleDismissButton() {
        textField.isSecureTextEntry = !textField.isSecureTextEntry
    }

    @objc private func textFieldDidChange() {
        if let text = textField.text, text.count > CON.cvvCount {
            textField.text = String(text.prefix(CON.cvvCount))
        }
    }

    private func setupErrorField(isError: Bool) {
        layer.borderColor = isError ? UIColor.error.cgColor : UIColor.borderGray.cgColor
        placeholderLabel.textColor = isError ? .error : .lightBlueDark
        placeholderLabel.text = isError ? CON.fieldErrorTitle : CON.fieldTitle
        textField.textColor = isError ? .error : .black
    }

    private func setupDismissButton(empty: Bool ) {
        vLine.isHidden = empty
        dismissButton.isHidden = empty
        if empty {
            textField.isSecureTextEntry = true
        }
    }
}

extension PaymentCardCvvField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        placeholderCenterConstr?.isActive = false
        placeholderLabel.font = CON.placeholderFontNotActive
        isInvalide = false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else {
            placeholderCenterConstr?.isActive = true
            placeholderLabel.font = CON.placeholderFontActive
            return
        }
        isInvalide = text.count != CON.cvvCount
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        cvcNumber = textField.text
        isValidated = textField.text?.count == CON.cvvCount

        NotificationCenter.default.post(name: .fieldsChanged, object: nil, userInfo: nil)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        let isInput = (string.rangeOfCharacter(from: allowedCharacters) != nil && characterSet.isSubset(of: allowedCharacters) && (textField.text?.count ?? 0) + string.count - range.length <= CON.cvvCount) || string.isEmpty
        if isInput {
            setupDismissButton(empty: oldText.replacingCharacters(in: r, with: string).count == 0)
        }
        return isInput
    }
}

