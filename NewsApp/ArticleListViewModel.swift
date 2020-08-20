//
//  ArticleListViewModel.swift
//  NewsApp
//
//  Created by Arjun P A on 20/08/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

enum ArticleListViewSortOrder {
    case ascending
    case descending
}

protocol ArticleListViewModelInterface {
    var numberOfRows: Int { get }
    func itemAtIndex(_ index: Int) -> ArticleViewModelInterface
    func fetchArticles()
    func sortArticlesBy(_ order: ArticleListViewSortOrder)
    func detailViewModelAtIndex(_ index: Int) -> ArticleDetailViewModelInterface
}


protocol ArticleListViewUpdater: class {
    func updateView()
    func onError()
}

final class ArticleListViewModel: ArticleListViewModelInterface {
    
    private let repository: ArticleListRepositoryInterface
    
    private var articleViewModels: [ArticleViewModel] = []
    
    weak var delegate: ArticleListViewUpdater?
    
    init(with repository: ArticleListRepositoryInterface) {
        self.repository = repository
    }
    
    func fetchArticles() {
        self.repository.fetchArticles { [weak self] result in
            switch result {
            case .success(let response):
                self?.dispatchResponse(response)
            case .failure(let error):
                self?.dispatchError(error)
            }
        }
    }
    
    func sortArticlesBy(_ order: ArticleListViewSortOrder) {
        let sortFunction: (ArticleViewModel, ArticleViewModel) -> Bool = { first, second in
            return order == .ascending ? first.article.publishDate < second.article.publishDate
                                       : first.article.publishDate > second.article.publishDate
        }
        self.articleViewModels.sort(by: sortFunction)
        self.delegate?.updateView()
    }
    
    var numberOfRows: Int {
        return self.articleViewModels.count
    }
    
    func itemAtIndex(_ index: Int) -> ArticleViewModelInterface {
        return self.articleViewModels[index]
    }
    
    func detailViewModelAtIndex(_ index: Int) -> ArticleDetailViewModelInterface {
        return ArticleDetailViewModel(article: self.articleViewModels[index].article, webViewHandler: WKWebViewHandler())
    }
    
    private func dispatchResponse(_ response: ArticleListResponse) {
        DispatchQueue.main.async {
            self.articleViewModels = response.articles.map({ ArticleViewModel(article: $0) })
            self.delegate?.updateView()
        }
    }
    
    private func dispatchError(_ error: Error) {
        DispatchQueue.main.async {
            self.delegate?.onError()
        }
    }
}
