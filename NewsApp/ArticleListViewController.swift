//
//  ArticleListViewController.swift
//  NewsApp
//
//  Created by Arjun P A on 18/08/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit

class ArticleListViewController: UIViewController {
    
    var articleListViewModel: ArticleListViewModelInterface?
    
    @IBOutlet private weak var articleListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.articleListViewModel?.fetchArticles()
    }
}

extension ArticleListViewController: ArticleListViewUpdater {
    
    func updateView() {
        self.articleListView.reloadData()
    }
    
    func onError() {
        
    }
}
