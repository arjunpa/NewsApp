//
//  RequestURLCache.swift
//  PhotoCollection
//
//  Created by Arjun P A on 19/08/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

final class RequestURLCache: URLCache {
    
    private static let expiryDateKey = "expiryDate"
    
    static let `default` = RequestURLCache(memoryCapacity: 10 * 1024 * 1024,
                                           diskCapacity: 25 * 1024 * 1024,
                                           diskPath: nil)
    
    /// The cache expiry in seconds.
    let defaultCacheExpiry: TimeInterval
    
    init(memoryCapacity: Int, diskCapacity: Int, diskPath path: String?, expiry: TimeInterval) {
        self.defaultCacheExpiry = expiry
        super.init(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: path)
    }
    
    override init(memoryCapacity: Int, diskCapacity: Int, diskPath path: String?) {
        self.defaultCacheExpiry = 43500
        super.init(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: path)
    }
    
    override func cachedResponse(for request: URLRequest) -> CachedURLResponse? {
        let selfType = type(of: self)
        let cachedResponse = super.cachedResponse(for: request)
        let userInfo = cachedResponse?.userInfo
        guard let shouldExpire = userInfo?[selfType.shouldExpireKey] as? Bool else {
            return nil
        }
        guard shouldExpire else { return cachedResponse }
        if let expiryDate = userInfo?[selfType.expiryDateKey] as? Date  {
            let age = userInfo?[selfType.cacheAge] as? TimeInterval ?? self.defaultCacheExpiry
            if expiryDate.timeIntervalSinceNow < -age {
                self.removeCachedResponse(for: request)
            } else {
                return cachedResponse
            }
        }
        return nil
    }
    
    override func storeCachedResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest) {

        let selfType = type(of: self)
        
        let shouldExpire = cachedResponse.userInfo?[selfType.shouldExpireKey] as? Bool ?? true
        
        var userInfo = cachedResponse.userInfo ?? [:]
        userInfo[selfType.shouldExpireKey] = shouldExpire
        
        if shouldExpire {
            if userInfo[selfType.expiryDateKey] as? Data == nil {
                userInfo[selfType.expiryDateKey] = Date()
            }
            
            if userInfo[selfType.cacheAge] as? TimeInterval == nil {
                userInfo[selfType.cacheAge] = self.defaultCacheExpiry
            }
        }
        super.storeCachedResponse(CachedURLResponse(response: cachedResponse.response,
                                                    data: cachedResponse.data,
                                                    userInfo: userInfo,
                                                    storagePolicy: cachedResponse.storagePolicy),
                                  for: request)
    }
}

extension RequestURLCache {
    static let shouldExpireKey = "shouldExpire"
    static let cacheAge = "cache-age"
}
