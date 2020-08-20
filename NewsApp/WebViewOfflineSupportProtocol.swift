//
//  WebViewOfflineSupportProtocol.swift
//  NewsApp
//
//  Created by Arjun P A on 20/08/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

protocol WebViewOfflineSupportProtocol {
    func cacheResponse(for cacheReequest: CacheRequestable)
    func cachedResponseString(for request: Requestable, completion: @escaping (Result<String?, Error>) -> Void)
}
