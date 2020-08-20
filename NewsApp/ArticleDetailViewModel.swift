//
//  ArticleDetailViewController.swift
//  NewsApp
//
//  Created by Arjun P A on 20/08/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation
import WebKit

protocol ArticleDetailViewModelInterface {
    var detailURL: URL? { get }
    var webViewHandler: WKNavigationDelegate & WebViewOfflineSupportProtocol { get }
    func addToOfflineStorage()
    func removeFromOfflineStorage()
    func offlineAvailability(completion: @escaping (Bool) -> Void)
}

protocol ArticleDetailViewDelegate: class {
    func didUpdateOfflineStatus(_ status: Bool)
}

final class ArticleDetailViewModel: ArticleDetailViewModelInterface {
    
    weak var viewDelegate: ArticleDetailViewDelegate?
    
    let detailURL: URL?
    
    let article: Article
    
    let webViewHandler: WKNavigationDelegate & WebViewOfflineSupportProtocol
    
    init(article: Article, webViewHandler: WKNavigationDelegate & WebViewOfflineSupportProtocol) {
        self.article = article
        self.detailURL = article.articleURL
        self.webViewHandler = webViewHandler
    }
    
    func addToOfflineStorage() {
        guard let detailURL = self.detailURL else { return }
        let request = Request(url: detailURL, method: .get, parameters: nil, headers: nil, encoding: RequestURLEncoding())
        let cacheReequest = CacheableRequest(request: request, expiry: .aged(86500))
        self.webViewHandler.cacheResponse(for: cacheReequest) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let status):
                    self?.viewDelegate?.didUpdateOfflineStatus(status)
                case .failure:
                    self?.viewDelegate?.didUpdateOfflineStatus(false)
                }
            }
        }
    }
    
    func removeFromOfflineStorage() {
        guard let detailURL = self.detailURL else { return }
        let request = Request(url: detailURL, method: .get, parameters: nil, headers: nil, encoding: RequestURLEncoding())
        self.webViewHandler.removeCachedResponse(for: request) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let status):
                    self?.viewDelegate?.didUpdateOfflineStatus(!status)
                case .failure:
                    self?.viewDelegate?.didUpdateOfflineStatus(true)
                }
            }
        }
    }
    
    func offlineAvailability(completion: @escaping (Bool) -> Void) {
        guard let detailURL = self.detailURL else { return }
        let request = Request(url: detailURL, method: .get, parameters: nil, headers: nil, encoding: RequestURLEncoding())
        self.webViewHandler.cachedResponseString(for: request) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let responseString):
                    completion(responseString != nil)
                case .failure:
                    completion(false)
                }
            }
        }
    }
}
