//
//  WKWebViewHandler.swift
//  NewsApp
//
//  Created by Arjun P A on 20/08/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation
import WebKit

final class WKWebViewHandler: NSObject, WKNavigationDelegate, WebViewOfflineSupportProtocol {
    
    static let defaultURLCache = DiskURLCache(with: RequestURLCache(memoryCapacity: 10 * 1024 * 1024,
                                                                    diskCapacity: 100 * 1024 * 1024,
                                                                    diskPath: nil))
    
    let urlCache: URLCacheable
    let service: APIServiceInterface
    
    private var isHandlingCacheRequest = false
    
    override init() {
        self.urlCache = type(of: self).defaultURLCache
        self.service = APIService()
        super.init()
    }
    
    init(with urlCache: URLCacheable = WKWebViewHandler.defaultURLCache, service: APIServiceInterface = APIService()) {
        self.urlCache = urlCache
        self.service = service
    }
    
    private func loadData(for request: Requestable, completion: @escaping (Result<APIHTTPDataResponse, Error>) -> Void) {
        self.service.request(for: request) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func cacheResponse(for cacheReequest: CacheRequestable, completion: CacheResponseCompletion?) {
        self.loadData(for: cacheReequest) { [weak self] result in
            switch result {
            case .success(let response):
                self?.urlCache.store(response: response, forRequest: cacheReequest, completion: { result in
                    switch result {
                    case .success(let status):
                        completion?(.success(status))
                    case .failure(let error):
                        completion?(.failure(error))
                    }
                })
            case .failure:
                break
            }
        }
    }
    
    func cachedResponseString(for request: Requestable, completion: @escaping (Result<String?, Error>) -> Void) {
        self.urlCache.get(forRequest: request) { result in
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(.success(nil))
                    return
                }
                guard let dataString = String(data: response.data, encoding: .utf8) else {
                    completion(.success(nil))
                    return
                }
                completion(.success(dataString))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func removeCachedResponse(for request: Requestable, completion: CacheResponseCompletion?) {
        self.urlCache.remove(forRequest: request, completion: completion)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url, let httpMethod = navigationAction.request.requestMethod, !self.isHandlingCacheRequest else {
            self.isHandlingCacheRequest = false
            decisionHandler(.allow)
            return
        }
        let request = Request(url: url,
                              method: httpMethod,
                              parameters: nil,
                              headers: navigationAction.request.allHTTPHeaderFields,
                              encoding: RequestURLEncoding())
        
        self.cachedResponseString(for: request) { result in
            switch result {
            case .success(let htmlDataString):
                guard let htmlDataString = htmlDataString else {
                    self.isHandlingCacheRequest = false
                    decisionHandler(.allow)
                    return
                }
                DispatchQueue.main.async {
                    webView.loadHTMLString(htmlDataString, baseURL: nil)
                }
                self.isHandlingCacheRequest = true
                decisionHandler(.cancel)
            case .failure:
                self.isHandlingCacheRequest = false
                decisionHandler(.allow)
            }
        }
    }
}
