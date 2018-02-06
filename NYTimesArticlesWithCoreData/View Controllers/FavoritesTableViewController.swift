//
//  FavoritesTableViewController.swift
//  NYTimesArticlesWithCoreData
//
//  Created by C4Q  on 2/6/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit
import CoreData

class FavoritesTableViewController: UITableViewController {

    lazy var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<Article> in
        let request = NSFetchRequest<Article>(entityName: "Article")
        let favoritedPred = NSPredicate(format: "isFavorite = true")
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.predicate = favoritedPred
        request.sortDescriptors = [sortDescriptor]
       let frc = NSFetchedResultsController(
        fetchRequest: request,
        managedObjectContext: CoreDataHelper.manager.getContext(),
        sectionNameKeyPath: "category.name", cacheName: nil)
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController.delegate = self
        configureTableView()
        do {
            try fetchedResultsController.performFetch()
        }
        catch {
            print(error)
        }
    }
    
    func configureTableView() {
        let tbNib = UINib(nibName: "ArticleTableViewCell", bundle: nil)
        tableView.register(tbNib, forCellReuseIdentifier: "articleCell")
    }


    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0}
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return 0 }
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return "" }
        return sectionInfo.name
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleTableViewCell
        let article = fetchedResultsController.object(at: indexPath)
        cell.configureSelf(with: article)
        return cell
    }
}

extension FavoritesTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            if let ip = indexPath {
                tableView.deleteRows(at: [ip], with: .fade)
            }
        case .update:
            if let ip = indexPath, let cell = tableView.cellForRow(at: ip) as? ArticleTableViewCell {
                cell.configureSelf(with: fetchedResultsController.object(at: ip))
            }
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

