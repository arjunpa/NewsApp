//
//  ArticleDetailWebViewController.swift
//  NewsApp
//
//  Created by Arjun P A on 20/08/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit
import WebKit

final class ArticleDetailWebViewController: UIViewController {
    
    var detailViewModel: ArticleDetailViewModelInterface? {
        didSet {
            self.webView.navigationDelegate = self.detailViewModel?.webViewHandler
        }
    }
    
    private let navigationDelegate = WKWebViewHandler()
    
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    override func viewDidLoad() {
        self.setupViews()
        guard let url = self.detailViewModel?.detailURL else { return }
        self.webView.loadURL(url: url)
    }
    
    private func setupViews() {
        self.view.addSubview(webView)
        NSLayoutConstraint.activate([
            self.webView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.webView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.webView.bottomAnchor),
            self.view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.webView.trailingAnchor)
        ])
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Offline",
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(didInteractWithOfflineAction))
    }
    
    @objc private func didInteractWithOfflineAction() {
        self.detailViewModel?.addToOfflineStorage()
    }
}

extension ArticleDetailWebViewController: StoryboardInstantiable {}
