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
        self.setupViewBindings()
    }
    
    private func setupViewBindings() {
        guard let url = self.detailViewModel?.detailURL else { return }
        
        self.detailViewModel?.offlineAvailability(completion: { [weak self] status in
            self?.configureRightBarItem(with: status)
        })
        
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
    }
    
    private func configureRightBarItem(with offlineStatus: Bool) {
        let title = offlineStatus ? "Remove" : "Offline"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: title,
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(didInteractWithRightButton))
    }
    
    @objc private func didInteractWithRightButton() {
        self.detailViewModel?.offlineAvailability(completion: { [weak self] status in
            if status {
                self?.detailViewModel?.removeFromOfflineStorage()
            } else {
                self?.detailViewModel?.addToOfflineStorage()
            }
        })
    }
}

extension ArticleDetailWebViewController: StoryboardInstantiable {}

extension ArticleDetailWebViewController: ArticleDetailViewDelegate {
    
    func didUpdateOfflineStatus(_ status: Bool) {
        self.configureRightBarItem(with: status)
    }
}
