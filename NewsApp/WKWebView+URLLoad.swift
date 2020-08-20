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
        let request = URLRequest(url: url)
        self.load(request)
    }
}
