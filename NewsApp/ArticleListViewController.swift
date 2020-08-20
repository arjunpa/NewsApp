//
//  ArticleListViewController.swift
//  NewsApp
//
//  Created by Arjun P A on 18/08/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit

final class ArticleListViewController: UIViewController {
    
    var articleListViewModel: ArticleListViewModelInterface?
    
    @IBOutlet private weak var articleListView: UITableView! {
        didSet {
            self.articleListView.dataSource = self
            self.articleListView.delegate = self
            self.articleListView.register(UINib(nibName: ArticleListTableViewCell.nibName,
                                                bundle: nil),
                                          forCellReuseIdentifier: ArticleListTableViewCell.reuseIdentifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.articleListViewModel?.fetchArticles()
    }
    
    private func configure() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sort",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(didInteractWithSortAction))
    }
    
    @objc private func didInteractWithSortAction() {
        
        //Bug in Action Sheet produces a constraint breakage error http://openradar.appspot.com/49289931
        
        let actionSheetPresentation = UIAlertController(title: "Sort",
                                                        message: "Sort articles either by descending or ascending.",
                                                        preferredStyle: .actionSheet)
        
        actionSheetPresentation.addAction(UIAlertAction(title: "Descending", style: .default, handler: { [weak self] _ in
            self?.articleListViewModel?.sortArticlesBy(.descending)
        }))
        
        actionSheetPresentation.addAction(UIAlertAction(title: "Ascending", style: .default, handler: { [weak self] _ in
            self?.articleListViewModel?.sortArticlesBy(.ascending)
        }))
        
        actionSheetPresentation.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { [weak actionSheetPresentation] _ in
            actionSheetPresentation?.dismiss(animated: true, completion: nil)
        }))
        
        self.present(actionSheetPresentation, animated: true, completion: nil)
    }
}

extension ArticleListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articleListViewModel?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = self.articleListViewModel,
              let cell = self.articleListView.dequeueReusableCell(withIdentifier: ArticleListTableViewCell.reuseIdentifier,
                                                                  for: indexPath) as? ArticleListTableViewCell
              else { return UITableViewCell() }
        cell.configure(with: viewModel.itemAtIndex(indexPath.row))
        return cell
    }
}

extension ArticleListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController: ArticleDetailWebViewController = UIStoryboard(storyboardName: .main).instantiateViewController()
        detailViewController.detailViewModel = self.articleListViewModel?.detailViewModelAtIndex(with: detailViewController, index: indexPath.row)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension ArticleListViewController: ArticleListViewUpdater {
    
    func updateView() {
        self.articleListView.reloadData()
    }
    
    func onError() {
        
    }
}

extension ArticleListViewController: StoryboardInstantiable {}
