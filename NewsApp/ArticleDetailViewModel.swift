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
}

final class ArticleDetailViewModel: ArticleDetailViewModelInterface {
    
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
        self.webViewHandler.cacheResponse(for: cacheReequest)
    }
}
