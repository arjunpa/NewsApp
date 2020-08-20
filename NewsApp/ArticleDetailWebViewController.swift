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
    
    var detailViewModel: ArticleDetailViewModelInterface?
    
    @IBOutlet private weak var webView: WKWebView!
    
    override func viewDidLoad() {
        guard let url = self.detailViewModel?.detailURL else { return }
        self.webView.loadURL(url: url)
    }
}

extension ArticleDetailWebViewController: StoryboardInstantiable {}
