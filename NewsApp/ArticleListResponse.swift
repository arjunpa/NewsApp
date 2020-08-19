//
//  ArticleListResponse.swift
//  NewsApp
//
//  Created by Arjun P A on 19/08/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

struct ArticleListResponse: Decodable {
    
    enum ResponseStatus: String, Decodable {
        case ok
        case other
    }
    
    private enum CodingKeys: String, CodingKey {
        case status
        case articles
    }
    
    let status: ResponseStatus
    let articles: [Article]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decode(ResponseStatus.self, forKey: .status)
        self.articles = try container.decode([Article].self, forKey: .articles)
    }
}

struct Article: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case author
        case title
        case description
        case articleURL = "url"
        case imageURL = "urlToImage"
    }
    
    let author: String?
    let title: String
    let description: String
    let articleURL: URL
    let imageURL: URL
}