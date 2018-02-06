//
//  NYTimesAPIClient.swift
//  NYTimesArticlesWithCoreData
//
//  Created by C4Q  on 2/6/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import Foundation

class NYTimesAPIClient {
    private init() {}
    static let manager = NYTimesAPIClient()
    private let apiBase = "https://api.nytimes.com/svc/topstories/v2/"
    private let apiEnd = ".json?api-key="
    private let apiKey = "fe8c8520db7244e29c3a10521417768a"
    
    func getArticles(for categoryName: String,
                     completionHandler: @escaping ([Article]) -> Void,
                     errorHandler: @escaping (Error) -> Void) {
        
        if let savedCategory = CoreDataHelper.manager.getCategory(with: categoryName),
            savedCategory.isRecentEnough() {
            let articles = (savedCategory.articles?.allObjects as! [Article])
            completionHandler(articles.sorted{$0.timestamp! > $1.timestamp!})
            return
        }
        
        let urlStr = apiBase + categoryName + apiEnd + apiKey
        guard let url = URL(string: urlStr) else {
            errorHandler(AppError.badURL(urlStr))
            return
        }
        let request = URLRequest(url: url)
        let completion: (Data) -> Void = {(data) in
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    errorHandler(AppError.badJSON(data))
                    return
                }
                let categoryToUse: Category
                if let savedCategory = CoreDataHelper.manager.getCategory(with: categoryName) {
                    categoryToUse = savedCategory
                } else {
                    let newCategory = Category(context: CoreDataHelper.manager.getContext())
                    newCategory.populate(from: jsonObject)
                    categoryToUse = newCategory
                }
                
                if let resultsDictArr = jsonObject["results"] as? [[String: Any]] {
                    var articles = [Article]()
                    for articleDict in resultsDictArr {
                        //Fetch all articles with this dictionary
                        if let savedArticle = CoreDataHelper.manager.getArticle(with: articleDict) {
                            //Add it to the articles array and continue
                            articles.append(savedArticle)
                            continue
                        }
                        let newArticle = Article(context: CoreDataHelper.manager.getContext())
                        newArticle.populate(from: articleDict)
                        newArticle.category = categoryToUse
                        articles.append(newArticle)
                    }
                    CoreDataHelper.manager.saveContext()
                    completionHandler(articles)
                }
            }
            catch {
                print(error)
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: completion, errorHandler: errorHandler)
    }
}
