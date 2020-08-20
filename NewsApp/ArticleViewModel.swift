//
//  ArticleViewModel.swift
//  NewsApp
//
//  Created by Arjun P A on 20/08/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

protocol ArticleViewModelInterface {
    var title: String { get }
    var description: String { get }
}

final class ArticleViewModel: ArticleViewModelInterface {
    
    let article: Article
    let title: String
    let description: String
    
    init(article: Article) {
        self.article = article
        self.title = article.title
        self.description = article.description
    }
}
