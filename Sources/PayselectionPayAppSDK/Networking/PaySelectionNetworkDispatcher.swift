//
//  PaySelectionNetworkDispatcher.swift
//  PayselectionPayAppSDK
//
//  Created by Alexander Kogalovsky on 20.10.22.
//

import Foundation

protocol PayselectionNetworkDispatcher {
    func dispatch(request: PayselectionRequest,
                  onSuccess: @escaping (Data, URLResponse) -> Void,
                  onError: @escaping (Error) -> Void,
                  onRedirect: ((URLRequest) -> Bool)?)
}

class PayselectionURLSessionNetworkDispatcher: NSObject, PayselectionNetworkDispatcher {
    
    private lazy var session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
    static let shared = PayselectionURLSessionNetworkDispatcher()
    private var onRedirect: ((URLRequest) -> Bool)?
    
    private override init() {}

    func dispatch(request: PayselectionRequest,
                         onSuccess: @escaping (Data, URLResponse) -> Void,
                         onError: @escaping (Error) -> Void,
                         onRedirect: ((URLRequest) -> Bool)? = nil) {
        self.onRedirect = onRedirect
        
        guard let url = URL(string: request.path) else {
            onError(PayselectionError.invalidURL)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        if let body = request.body {
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .withoutEscapingSlashes
                let data = try encoder.encode(body)
                urlRequest.httpBody = data
            } catch let error {
                onError(PayselectionError.encodingError(error))
                return
            }
        }

        var headers = request.headers
        headers["Content-Type"] = "application/json"
        urlRequest.allHTTPHeaderFields = headers
        
        session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                onError(PayselectionError.transportError(error))
                return
            }
            
            guard let data = data,
                  let response = response else {
                onError(PayselectionError.noData)
                return
            }
            onSuccess(data, response)
        
        }.resume()
    }
}

extension PayselectionURLSessionNetworkDispatcher: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession,
                           task: URLSessionTask,
                           willPerformHTTPRedirection response: HTTPURLResponse,
                           newRequest request: URLRequest,
                           completionHandler: @escaping (URLRequest?) -> Void) {
        if let _ = onRedirect?(request) {
            completionHandler(request)
        } else {
            completionHandler(nil)
        }
    }
}
