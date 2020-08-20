//
//  NewsListRepository.swift
//  NewsApp
//
//  Created by Arjun P A on 19/08/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

protocol ArticleListRepositoryInterface {
    
    func fetchArticles(completion: @escaping (Result<ArticleListResponse, Error>) -> Void)
}

final class ArticleListRepository: ArticleListRepositoryInterface {
    
    private let apiService: APIServiceInterface
    
    private let diskCache: URLCacheable
    
    init(with apiService: APIServiceInterface, diskCache: URLCacheable = DiskURLCache.default) {
        self.apiService = apiService
        self.diskCache = diskCache
    }
    
    func fetchArticles(completion: @escaping (Result<ArticleListResponse, Error>) -> Void) {
        
        let request = Request(url: APIEndPoint.photosAPI,
                              method: .get,
                              parameters: nil,
                              headers: nil,
                              encoding: GetRequestEncoding())
        let cacheableRequest = CacheableRequest(request: request,
                                                expiry: .aged(86400))
        
        self.apiService.request(for: request) {[weak self] (result: Result<APIHTTPDecodableResponse<ArticleListResponse>, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.decoded))
            case .failure(let error):
                self?.handleFailureIfRequired(forRequest: cacheableRequest, error: error, completion: completion)
            }
        }
    }
    
    private func handleFailureIfRequired(forRequest request: CacheableRequest,
                                         error: Error,
                                         completion: @escaping (Result<ArticleListResponse, Error>) -> Void) {
        self.diskCache.get(forRequest: request) { (result: Result<APIHTTPDecodableResponse<ArticleListResponse>?, Error>) in
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(.failure(error))
                    return
                }
                completion(.success(response.decoded))
            case .failure:
                completion(.failure(error))
            }
        }
    }
}
