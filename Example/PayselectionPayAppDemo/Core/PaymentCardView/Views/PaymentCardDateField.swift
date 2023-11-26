//
//  PaymentCardDateField.swift
//  PayselectionPayAppDemo
//
//  Created by  on 17.11.23.
//

import UIKit

class PaymentCardDateField: UIView {
    // MARK: - Const
    struct CON {
        static let fieldTitle = NSLocalizedString("ММ / ГГ", comment: "")
        static let fieldErrorTitle = NSLocalizedString("Ошибка даты", comment: "")
        static let minDateYear: Int = 21
        static let widthButton: CGFloat = 57.0
        static let paddingField: CGFloat = 8.0
        static let paddingLeadField: CGFloat = 16.0
        static let placeholderFontActive: UIFont = .raleway(.medium, size: 18)
        static let placeholderFontNotActive: UIFont = .raleway(.medium, size: 12)
    }

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
    private(set) var cardExpMonth: Int?
    private(set) var cardExpYear: Int?
    private(set) var isInvalide: Bool = false {
        didSet {
            setupErrorField(isError: isInvalide)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    func setupDate(cardExpMonth: String?, cardExpYear: String?) {
        textField.text = nil
        if let cardExpMonth, let cardExpYear {
            textField.text = "\(cardExpMonth)/\(cardExpYear)"
        }
        textFieldDidChangeSelection(textField)
        if cardExpMonth == nil {
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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        layer.cornerRadius = 8
        layer.borderColor = UIColor.borderGray.cgColor
        layer.borderWidth = 1

        addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -CON.paddingField),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CON.paddingLeadField),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -CON.paddingField)
        ])

        addSubview(placeholderLabel)
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: CON.paddingField),
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CON.paddingLeadField)
        ])
        placeholderCenterConstr = placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        placeholderCenterConstr?.isActive = true
    }
}

extension PaymentCardDateField: UITextFieldDelegate {
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
        isInvalide = !expDateValidation(text)
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        isValidated = expDateValidation(textField.text)
        NotificationCenter.default.post(name: .fieldsChanged, object: nil, userInfo: nil)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        let updatedText = oldText.replacingCharacters(in: r, with: string)

        if string == "" {
            if updatedText.count == 2 {
                textField.text = "\(updatedText.prefix(1))"
                return false
            }
        } else if updatedText.count == 1 {
            if updatedText > "1" {
                return false
            }
        } else if updatedText.count == 2 {
            if updatedText <= "12" {
                textField.text = "\(updatedText)/"
            }
            return false
        } else if updatedText.count == 5 {
            return self.expDateValidation(updatedText)
        } else if updatedText.count > 5 {
            return false
        }
        return true
    }

    func expDateValidation(_ dateStr: String?) -> Bool {
        guard let dateStr else { return false}

        cardExpYear = Int(dateStr.suffix(2)) ?? 0
        cardExpMonth = Int(dateStr.prefix(2)) ?? 0

        if cardExpYear! >= CON.minDateYear {
            return (1 ... 12).contains(cardExpMonth!)
        } else {
            return false
        }
    }
}
