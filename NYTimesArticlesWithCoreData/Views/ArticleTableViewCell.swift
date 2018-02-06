//
//  ArticleTableViewCell.swift
//  NYTimesArticlesWithCoreData
//
//  Created by C4Q  on 2/6/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var abstractLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    private var article: Article! {
        didSet {
            titleLabel.text = article.title
            abstractLabel.text = article.abstract
            favoriteButton.setImage(article.isFavorite ? #imageLiteral(resourceName: "filledStar") : #imageLiteral(resourceName: "unfilledStar"), for: .normal)
        }
    }
    
    func configureSelf(with article: Article) {
        self.article = article
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        if article.isFavorite {
            article.isFavorite = false
            favoriteButton.setImage(#imageLiteral(resourceName: "unfilledStar"), for: .normal)
        } else {
            article.isFavorite = true
            favoriteButton.setImage(#imageLiteral(resourceName: "filledStar"), for: .normal)
        }
    }
    
}
