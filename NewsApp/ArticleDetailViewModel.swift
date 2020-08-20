//
//  ArticleDetailViewController.swift
//  NewsApp
//
//  Created by Arjun P A on 20/08/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

protocol ArticleDetailViewModelInterface {
    var detailURL: URL? { get }
}

final class ArticleDetailViewModel: ArticleDetailViewModelInterface {
    
    let detailURL: URL?
    
    let article: Article
    
    init(article: Article) {
        self.article = article
        self.detailURL = article.articleURL
    }
}
