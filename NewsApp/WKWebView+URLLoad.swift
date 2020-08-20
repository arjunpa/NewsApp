//
//  WKWebView+URLLoad.swift
//  NewsApp
//
//  Created by Arjun P A on 20/08/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit
import WebKit

extension WKWebView {
    
    func loadURL(url: URL) {
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        self.load(request)
    }
}
