//
//  ArticleListTableViewCell.swift
//  NewsApp
//
//  Created by Arjun P A on 20/08/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit

class ArticleListTableViewCell: UITableViewCell {
    
    private enum Constants {
        static let titleLabelFont = UIFont(name: "HelveticaNeue-CondensedBold", size: 16.0) ?? UIFont.systemFont(ofSize: 16.0)
        static let descriptionLabelFont = UIFont(name: "HelveticaNeue-Thin", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = Constants.titleLabelFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = Constants.descriptionLabelFont
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    @IBOutlet private weak var stackView: UIStackView! {
        didSet {
            self.stackView.addArrangedSubview(self.titleLabel)
            self.stackView.addArrangedSubview(self.descriptionLabel)
        }
    }
    
    func configure(with viewModel: ArticleViewModelInterface) {
        self.titleLabel.text = viewModel.title
        self.descriptionLabel.text = viewModel.description
    }
}
