//
//  ThreeDsProcessor.swift
//  
//
//  Created by Alexander Kogalovsky on 23.09.23.
//

import Foundation
import WebKit

public protocol ThreeDsListenerDelegate: AnyObject {
    func willPresentWebView(_ webView: WKWebView)
    func onAuthorizationCompleted()
    func onAuthorizationFailed(error: Error)
}

public class ThreeDsProcessor: NSObject {
    
    private let success = "TransactionStatus:success"
    private let fail = "TransactionStatus:fail"
    private let badRequest = "ERR_BAD_REQUEST"
    
    public weak var delegate: ThreeDsListenerDelegate?
    
    public func confirm3DSpayment(withUrl url: URL) {
        
        let source = getJsSource()
        let webView = WKWebView()
        let script = WKUserScript(source: source, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        webView.configuration.userContentController.addUserScript(script)
        webView.configuration.userContentController.add(self, name: "logHandler")
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        
        delegate?.willPresentWebView(webView)
    }
    
    private func getJsSource() -> String {
        let source = """
            function log(type, args) {
              window.webkit.messageHandlers.logHandler.postMessage(
                `JS ${type}: ${Object.values(args)
                  .map(v => typeof(v) === "undefined" ? "undefined" : typeof(v) === "object" ? JSON.stringify(v) : v.toString())
                  .map(v => v.substring(0, 2000)) // Limit msg to 2000 chars
                  .join(", ")}`
              )
            }

            let originalLog = console.log
            let originalError = console.error

            console.log = function() { log("log", arguments); originalLog.apply(null, arguments) }
            console.error = function() { log("error", arguments); originalError.apply(null, arguments) }
        """
        return source
    }
}

extension ThreeDsProcessor: WKScriptMessageHandler {
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let log = message.body as? String else {
            delegate?.onAuthorizationFailed(error: ThreeDsError.failedToReadConsoleLog)
            return
        }
        
        if log.contains(success) {
            delegate?.onAuthorizationCompleted()
            return
        }
        
        if log.contains(fail) {
            delegate?.onAuthorizationFailed(error: ThreeDsError.authorizationFailed)
            return
        }
        
        if log.contains(badRequest) {
            delegate?.onAuthorizationFailed(error: ThreeDsError.badRequest)
        }
    }
}

public enum ThreeDsError: Error {
    case badRequest
    case authorizationFailed
    case failedToReadConsoleLog
}
