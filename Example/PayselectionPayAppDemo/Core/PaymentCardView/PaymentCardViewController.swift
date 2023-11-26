//
//  PaymentCardViewController.swift
//  PayselectionPayAppDemo
//
//  Created by  on 16.11.23.
//

import UIKit
import PayselectionPayAppSDK
import WebKit

class PaymentCardViewController: UIViewController {
    // MARK: - Const
    struct MOC {
        static let amount: String = "446"
    }
    struct CON {
        static let titleName = NSLocalizedString("Оплата картой", comment: "")
        static let maxDimmedAlpha: CGFloat = 0.8
        static let minDismissiblePanHeight: CGFloat = 20
        static let minTopSpacing: CGFloat = 80
        static let contentPadding: CGFloat = 24.0
        static let contentTopPadding: CGFloat = 16.0
    }

    // MARK: - UI
    private lazy var mainContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var topBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var barLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .popupBg
        view.alpha = 0
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .raleway(.bold, size: 24)
        label.textAlignment = .center
        label.text = CON.titleName
        return label
    }()

    private var observer: NSObjectProtocol?
    lazy var paymentContainer = PaymentCardContainer()
    var webview: WebViewController?
    var paymentCardModel: PaymentCardModel?

    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupGestures()
        setupObservers()

        // observer for close payment
        observer = NotificationCenter.default.addObserver(forName: .dismissPayment, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            dismissSheet()
        }
    }

    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer, name: .dismissPayment, object: nil)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatePresent()
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func setupViews() {
        view.backgroundColor = .clear
        view.addSubview(dimmedView)
        NSLayoutConstraint.activate([
            // Set dimmedView edges to superview
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // Container View
        view.addSubview(mainContainerView)
        NSLayoutConstraint.activate([
            mainContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainContainerView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: CON.minTopSpacing)
        ])

        // Top draggable bar view
        mainContainerView.addSubview(topBarView)
        NSLayoutConstraint.activate([
            topBarView.topAnchor.constraint(equalTo: mainContainerView.topAnchor),
            topBarView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor),
            topBarView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor),
            topBarView.heightAnchor.constraint(equalToConstant: 54)
        ])
        topBarView.addSubview(barLineView)
        NSLayoutConstraint.activate([
            barLineView.centerXAnchor.constraint(equalTo: topBarView.centerXAnchor),
            barLineView.topAnchor.constraint(equalTo: topBarView.topAnchor, constant: 8),
            barLineView.widthAnchor.constraint(equalToConstant: 40),
            barLineView.heightAnchor.constraint(equalToConstant: 4)
        ])

        // Title
        topBarView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: topBarView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topBarView.topAnchor, constant: CON.contentPadding)
        ])

        // Content View
        mainContainerView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor, constant: CON.contentPadding),
            contentView.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor, constant: -CON.contentPadding),
            contentView.topAnchor.constraint(equalTo: topBarView.bottomAnchor, constant: CON.contentTopPadding),
            contentView.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: -(CON.contentTopPadding * 2))
        ])

        // add container
        bindContainer()
        setContent(content: paymentContainer)

        // add default card
        paymentContainer.addCard()
        // add local cards
        for card in PaymentCardService.instance.cards {
            paymentContainer.addCard(card)
        }
    }

    private func bindContainer() {
        // save card
        paymentContainer.handlerSaveCard = { [weak self] in
            guard let self else { return }
            PaymentCardService.instance.saveCard($0)
            self.paymentContainer.addCard($0, isNew: true)
        }

        // pay by card
        paymentContainer.handlerPayByCard = { [weak self] model in
            guard let self else { return }
            showLoading()
            PaymentCardService.instance.updateCard(model)
            PaymentCardService.instance.pay(cardNumber: model.cardNumber,
                                            cardExpMonth: model.cardExpMonth,
                                            cardExpYear: model.cardExpYear,
                                            cvc: model.cvc,
                                            handlerRedirectUrl: {
                self.hideLoading()
                self.paymentCardModel = model
                PaymentCardService.instance.confirm3DSpayment(redirectUrlString: $0).delegate = self
            }, handlerError: { [weak self] _ in
                guard let self else { return }
                self.hideLoading()
                present(by: .error)
            })
        }
    }

    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapDimmedView))
        dimmedView.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        topBarView.addGestureRecognizer(panGesture)
    }

    @objc private func handleTapDimmedView() {
        dismissSheet()
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let isDraggingDown = translation.y > 0
        guard isDraggingDown else { return }
        
        let pannedHeight = translation.y
        let currentY = self.view.frame.height - self.mainContainerView.frame.height
        switch gesture.state {
        case .changed:
            self.mainContainerView.frame.origin.y = currentY + pannedHeight
        case .ended:
            if pannedHeight >= CON.minDismissiblePanHeight {
                dismissSheet()
            } else {
                self.mainContainerView.frame.origin.y = currentY
            }
        default:
            break
        }
    }

    private func animatePresent() {
        dimmedView.alpha = 0
        mainContainerView.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.mainContainerView.transform = .identity
        }
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let self = self else { return }
            self.dimmedView.alpha = CON.maxDimmedAlpha
        }
    }

    private func setContent(content: UIView) {
        contentView.addSubview(content)
        NSLayoutConstraint.activate([
            content.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            content.topAnchor.constraint(equalTo: contentView.topAnchor),
            content.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        view.layoutIfNeeded()
    }

    @objc private func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            view.frame.origin.y = -keyboardSize.height
        }
    }

    @objc private func keyboardWillHide(_ notification: NSNotification) {
        view.frame.origin.y = 0
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

    // MARK: - Public
    func dismissSheet() {
        UIView.animate(withDuration: 0.2, animations: {  [weak self] in
            guard let self = self else { return }
            self.dimmedView.alpha = CON.maxDimmedAlpha
            self.mainContainerView.frame.origin.y = self.view.frame.height
        }, completion: {  [weak self] _ in
            guard let self else { return }
            self.dismiss(animated: false)
        })
    }
}

extension PaymentCardViewController: ThreeDsListenerDelegate {
    func willPresentWebView(_ webView: WKWebView) {
        let web = present(by: .webview, object: webView)
        webview = web as? WebViewController
        webview?.handlerCompletion = { [weak self] in
                guard let self else { return }
                self.present(by: .error)
        }
        if webview == nil {
            self.present(by: .error)
        }
    }

    func onAuthorizationCompleted() {
        guard let webview else { return }
        webview.dismiss { [weak self] in
            guard let self, let paymentCardModel else { return }
            self.present(by: .result, object: paymentCardModel.cardNumber)
            self.paymentCardModel = nil
        }
    }

    func onAuthorizationFailed(error: Error) {
        guard let webview else { return }
        webview.dismiss { [weak self] in
            guard let self else { return }
            self.present(by: .error)
        }
    }
}

extension PaymentCardViewController {
    // MARK: - Loader
        func hideLoading() {
            let existingView = self.view.viewWithTag(99)
            existingView?.removeFromSuperview()
        }

        func showLoading(_ loadingText: String? = nil, clear: Bool = false) {
            let existingView = self.view.viewWithTag(99)
            if existingView != nil {
                return
            }
            guard let loadingView = self.makeLoadingView() else { return }
            loadingView.tag = 99
            self.view.addSubview(loadingView)
        }

        private func makeLoadingView() -> UIView? {
            let loadingView = UIView(frame: UIScreen.main.bounds)
            loadingView.backgroundColor = .clear
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            activityIndicator.layer.cornerRadius = 6
            activityIndicator.center = loadingView.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.style = .large
            activityIndicator.color = .lightBlueDark
            activityIndicator.startAnimating()
            loadingView.addSubview(activityIndicator)
            return loadingView
        }
}
