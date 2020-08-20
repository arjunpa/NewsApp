//
//  DiskURLCache.swift
//  PhotoCollection
//
//  Created by Arjun P A on 19/08/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

final class DiskURLCache: URLCacheable {
    
    enum DiskCacheError: Error {
        case invalidRequest
        case noHTTPURLResponse
        case fatalError
    }
    
    static let `default` = DiskURLCache(with: RequestURLCache.default)
    
    let urlCache: RequestURLCache
    
    private let concurrentQueue = DispatchQueue(label: "com.diskurlcache",
                                                attributes: [.concurrent])
    
    init(with urlCache: RequestURLCache) {
        self.urlCache = urlCache
    }
    
    func store<T: Decodable>(response: APIHTTPDecodableResponse<T>, forRequest request: CacheRequestable, completion: URLCacheableStoreCompletion?) {
        self.store(data: response.data, response: response.httpResponse, forRequest: request, completion: completion)
    }
    
    func store(response: APIHTTPDataResponse, forRequest request: CacheRequestable, completion: URLCacheableStoreCompletion?) {
        self.store(data: response.data, response: response.httpResponse, forRequest: request, completion: completion)
    }
    
    private func store(data: Data, response: HTTPURLResponse?, forRequest request: CacheRequestable, completion: URLCacheableStoreCompletion?) {
        self.concurrentQueue.async(flags: .barrier) { [weak self] in
            
            do {
                let urlRequest = try request.asURLRequest()
                guard let httpResponse = response else {
                    completion?(.failure(DiskCacheError.noHTTPURLResponse))
                    return
                }
                
                guard let cachedResponse = self?.cachedResponse(fromRequest: request, httpResponse: httpResponse, data: data) else {
                    completion?(.failure(DiskCacheError.fatalError))
                    return
                }
                
                self?.urlCache.storeCachedResponse(cachedResponse,
                                                   for: urlRequest)
                completion?(.success(true))
            } catch {
                completion?(.failure(error))
            }
        }
    }
    
    func get<T: Decodable>(forRequest request: Requestable, completion: @escaping (Result<APIHTTPDecodableResponse<T>?, Error>) -> Void) {
        
        self.get(forRequest: request) { (result: Result<CachedURLResponse?, Error>) in
            switch result {
            case .success(let cachedResponse):
                guard let cachedResponse = cachedResponse else {
                    completion(.success(nil))
                    return
                }
                
                guard let httpURLResponse = cachedResponse.response as? HTTPURLResponse else {
                    completion(.failure(DiskCacheError.noHTTPURLResponse))
                    return
                }
                
                do {
                    let decoded = try cachedResponse.decoded(with: T.self)
                    completion(.success(APIHTTPDecodableResponse(data: cachedResponse.data,
                                                                 decoded: decoded,
                                                                 httpResponse: httpURLResponse)))
                } catch {
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func get(forRequest request: Requestable, completion: @escaping (Result<APIHTTPDataResponse?, Error>) -> Void) {
        self.get(forRequest: request) { (result: Result<CachedURLResponse?, Error>) in
            switch result {
            case .success(let cachedResponse):
                guard let cachedResponse = cachedResponse else {
                    completion(.success(nil))
                    return
                }
                
                guard let httpURLResponse = cachedResponse.response as? HTTPURLResponse else {
                    completion(.failure(DiskCacheError.noHTTPURLResponse))
                    return
                }
                
                completion(.success(APIHTTPDataResponse(data: cachedResponse.data, httpResponse: httpURLResponse)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func get(forRequest request: Requestable, completion: @escaping (Result<CachedURLResponse?, Error>) -> Void) {
        self.concurrentQueue.async { [weak self] in
            do {
                let urlRequest = try request.asURLRequest()
                guard let cachedResponse = self?.urlCache.cachedResponse(for: urlRequest) else {
                    completion(.success(nil))
                    return
                }
                completion(.success(cachedResponse))
                
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func remove(forRequest request: Requestable, completion: URLCacheableStoreCompletion?) {
        do {
            let urlRequest = try request.asURLRequest()
            self.concurrentQueue.async(flags: .barrier) { [weak self] in
                self?.urlCache.removeCachedResponse(for: urlRequest)
                completion?(.success(true))
            }
        } catch {
            completion?(.failure(error))
        }
    }
    
    private func cachedResponse(fromRequest request: CacheRequestable,
                                httpResponse: HTTPURLResponse,
                                data: Data) -> CachedURLResponse {
        var userInfo: [AnyHashable : Any] = [:]
        
        switch request.expiry {
        case .never:
            userInfo[RequestURLCache.shouldExpireKey] = false
        case .aged(let interval):
            userInfo[RequestURLCache.shouldExpireKey] = true
            userInfo[RequestURLCache.cacheAge] = interval
        }
        
        let cachedResponse = CachedURLResponse(response: httpResponse, data: data, userInfo: userInfo, storagePolicy: .allowed)
        return cachedResponse
    }
}
