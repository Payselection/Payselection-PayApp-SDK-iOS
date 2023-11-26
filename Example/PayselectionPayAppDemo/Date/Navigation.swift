//
//  Navigation.swift
//  PayselectionPayAppDemo
//
//  Created by  on 20.11.23.
//

import UIKit
import WebKit

enum NavigationNameType {
    case error
    case webview
    case result
    case payment
}

extension UIViewController {
    private func presentFull(_ viewController: UIViewController, animated: Bool = true) {
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .coverVertical
        present(viewController, animated: animated, completion: nil)
    }

    @discardableResult func present(by type: NavigationNameType, object: Any? = nil) -> UIViewController? {
        var viewController: UIViewController!
        var animated: Bool = true
        switch type {
        case .error:
            viewController = MessageViewController()
        case .webview:
            guard let webview = object as? WKWebView else {
                viewController = MessageViewController()
                return viewController
            }
            viewController = WebViewController(webView: webview)
        case .result:
            guard let number = object as? String else {
                viewController = MessageViewController()
                return viewController
            }
            viewController = ResultViewController(cardNumber: number)
        case .payment:
            viewController = PaymentCardViewController()
            animated = false
        }
        presentFull(viewController, animated: animated)
        return viewController
    }
}
