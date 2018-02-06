//
//  CoreDataHelper.swift
//  NYTimesArticlesWithCoreData
//
//  Created by C4Q  on 2/6/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import CoreData
import UIKit

enum ManagedObjectType: String {
    case article = "Article"
    case category = "Category"
}


class CoreDataHelper {
    private init() {}
    static let manager = CoreDataHelper()
    private let delegate = (UIApplication.shared.delegate as! AppDelegate)
    func getContext() -> NSManagedObjectContext {
        return delegate.persistentContainer.viewContext
    }
    func saveContext() {
        delegate.saveContext()
    }
    func getCategory(with name: String) -> Category? {
        let fetchRequest = NSFetchRequest<Category>(entityName:
        "Category")
        let namePredicate = NSPredicate(format: "name = %@", name)
        fetchRequest.predicate = namePredicate
        do {
            let categories = try getContext().fetch(fetchRequest)
            return categories.first
        }
        catch {
            print(error)
            return nil
        }
    }
    func getArticle(with dict: [String: Any]) -> Article? {
        if let urlStr = dict["url"] as? String {
            let fetchRequest = NSFetchRequest<Article>(entityName: "Article")
            let urlPredicate = NSPredicate(format: "url = %@", urlStr)
            fetchRequest.predicate = urlPredicate
            do {
                let articles = try getContext().fetch(fetchRequest)
                return articles.first
            }
            catch {
                print(error)
                return nil
            }
        }
        return nil
    }
    func deleteAll(managedObjectType: ManagedObjectType) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: managedObjectType.rawValue)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try getContext().execute(deleteRequest)
            try getContext().save()
        } catch {
            print(error)
        }
    }
}
