//
//  ViewController.swift
//  NYTimesArticlesWithCoreData
//
//  Created by C4Q  on 2/6/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit

class ArticlesViewController: UIViewController {
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var articlesTableView: UITableView!
    @IBOutlet weak var categoriesCollectionViewLayout: UICollectionViewFlowLayout!
    
    let categories = ["home", "opinion", "world", "national", "politics", "upshot", "nyregion", "business", "technology", "science", "health", "sports", "arts", "books", "movies", "theater", "sundayreview", "fashion", "tmagazine", "food", "travel", "magazine", "realestate", "automobiles", "obituaries", "insider" ]
    
    var selectedCategoryName: String?
    
    var articles = [Article]() {
        didSet {
            articlesTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureTableView()
        loadArticles(with: categories[0])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedCategoryName = selectedCategoryName {
            loadArticles(with: selectedCategoryName)
        }
    }
    
    func configureCollectionView() {
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        let collectionCellNib = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        categoriesCollectionView.register(collectionCellNib, forCellWithReuseIdentifier: "categoryCell")
        categoriesCollectionViewLayout.estimatedItemSize = CGSize(width: 100, height: 50)
    }
    
    func configureTableView() {
        articlesTableView.dataSource = self
        let tableViewNib = UINib(nibName: "ArticleTableViewCell", bundle: nil)
        articlesTableView.register(tableViewNib, forCellReuseIdentifier: "articleCell")
    }
    
    func loadArticles(with categoryName: String) {
        NYTimesAPIClient.manager.getArticles(for: categoryName,
                                             completionHandler: {self.articles = $0},
                                             errorHandler: {print($0)})
    }
}

extension ArticlesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
        let categoryName = categories[indexPath.row]
        cell.categoryLabel.text = categoryName
        return cell
    }
}

extension ArticlesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let catName = categories[indexPath.row]
        selectedCategoryName = catName
        loadArticles(with: catName)
    }
}

extension ArticlesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = articlesTableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleTableViewCell
        let article = articles[indexPath.row]
        cell.configureSelf(with: article)
        return cell
    }
}
