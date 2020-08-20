//
//  URLCacheable.swift
//  PhotoCollection
//
//  Created by Arjun P A on 19/08/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

typealias URLCacheableStoreCompletion = (Result<Bool, Error>) -> ()

protocol URLCacheable {
    func store(response: APIHTTPDataResponse, forRequest request: CacheRequestable, completion: URLCacheableStoreCompletion?)
    func store<T: Decodable>(response: APIHTTPDecodableResponse<T>, forRequest request: CacheRequestable, completion: URLCacheableStoreCompletion?)
    func get<T: Decodable>(forRequest request: Requestable, completion: @escaping (Result<APIHTTPDecodableResponse<T>?, Error>) -> Void)
    func get(forRequest request: Requestable, completion: @escaping (Result<APIHTTPDataResponse?, Error>) -> Void)
    func remove(forRequest request: Requestable, completion: URLCacheableStoreCompletion?)
}
