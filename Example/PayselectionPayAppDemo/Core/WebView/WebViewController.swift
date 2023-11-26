//
//  WebViewController.swift
//  PayselectionPayAppDemo
//
//  Created by  on 21.11.23.
//

import UIKit
import WebKit
import PayselectionPayAppSDK

class WebViewController: UIViewController {
    private lazy var dismissButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(dismissTap), for: .touchUpInside)
        button.setTitle("", for: .normal)
        button.backgroundColor = .black.withAlphaComponent(0.1)
        button.setImage(.buttonClose, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.layer.cornerRadius = 15
        return button
    }()

    var webView: WKWebView
    var handlerCompletion: (() -> Void)?

    init(webView: WKWebView) {
        self.webView = webView

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .white
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        view.addSubview(dismissButton)
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    @objc private func dismissTap() {
        dismiss(handlerCompletion)
    }

    func dismiss(_ completion: (() -> Void)? = nil) {
        dismiss(animated: true, completion: completion)
    }
}
