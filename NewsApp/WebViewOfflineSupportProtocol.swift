//
//  WebViewOfflineSupportProtocol.swift
//  NewsApp
//
//  Created by Arjun P A on 20/08/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

typealias CacheResponseCompletion = (Result<Bool, Error>) -> Void
protocol WebViewOfflineSupportProtocol {
    func cacheResponse(for cacheRequest: CacheRequestable, completion: CacheResponseCompletion? )
    func cachedResponseString(for request: Requestable, completion: @escaping (Result<String?, Error>) -> Void)
    func removeCachedResponse(for request: Requestable, completion: CacheResponseCompletion?)
}
