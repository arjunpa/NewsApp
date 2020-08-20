//
//  ArticleListViewModel.swift
//  NewsApp
//
//  Created by Arjun P A on 20/08/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

protocol ArticleListViewModelInterface {
    var numberOfRows: Int { get }
    func itemAtIndex(_ index: Int) -> ArticleViewModelInterface
    func fetchArticles()
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
    
    var numberOfRows: Int {
        return self.articleViewModels.count
    }
    
    func itemAtIndex(_ index: Int) -> ArticleViewModelInterface {
        return self.articleViewModels[index]
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
