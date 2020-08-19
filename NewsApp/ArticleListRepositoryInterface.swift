//
//  NewsListRepository.swift
//  NewsApp
//
//  Created by Arjun P A on 19/08/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

protocol ArticleListRepositoryInterface {
    
    func fetchArticles(with request: Requestable, completion: @escaping (Result<ArticleListResponse, Error>) -> Void)
}

final class ArticleListRepository: ArticleListRepositoryInterface {
    
    private let apiService: APIServiceInterface
    
    init(with apiService: APIServiceInterface) {
        self.apiService = apiService
    }
    
    func fetchArticles(with request: Requestable, completion: @escaping (Result<ArticleListResponse, Error>) -> Void) {
        self.apiService.request(for: request) { (result: Result<APIHTTPDecodableResponse<ArticleListResponse>, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.decoded))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
