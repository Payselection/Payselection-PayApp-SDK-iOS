//
//  MessageViewController.swift
//  PayselectionPayAppDemo
//
//  Created by  on 20.11.23.
//

import UIKit

class MessageViewController: UIViewController {
    // MARK: - Const
    struct CON {
        static let titleText: String = NSLocalizedString("Что-то пошло не так", comment: "")
        static let descriptionText: String = NSLocalizedString("Попробуйте повторить\nоплату позже", comment: "")
        static let closeButtonTitle: String = NSLocalizedString("Закрыть", comment: "")
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
        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 24.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let errorImageView: UIImageView = {
        let view = UIImageView(image: .iconError)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.contentMode = .center
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .raleway(.bold, size: 24)
        label.textAlignment = .center
        label.textColor = .black
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.02
        label.attributedText = NSMutableAttributedString(string: CON.titleText, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .raleway(.medium, size: 18)
        label.textAlignment = .center
        label.textColor = .gray
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.02
        label.attributedText = NSMutableAttributedString(string: CON.descriptionText, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return label
    }()

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
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CON.paddingView),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -CON.paddingView)
        ])
        stackView.addArrangedSubview(errorImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
    }

    @objc private func handleCloseButton() {
        dismiss(animated: true)
    }
}
