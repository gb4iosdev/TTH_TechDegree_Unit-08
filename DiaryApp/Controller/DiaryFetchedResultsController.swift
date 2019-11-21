//
//  DiaryFetchedResultsController.swift
//  DiaryApp
//
//  Created by Gavin Butler on 28-10-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit
import CoreData

//This FetchedResultsController is instantiated in the DiaryListController’s datasource.  It is kept in sync with core data using the delegate methods below and then is referred to in the tableview’s datasource delegate methods in order to populate the DiaryListController’s tableView when it’s loaded or reloaded.
class DiaryFetchedResultsController: NSFetchedResultsController<Item>, NSFetchedResultsControllerDelegate {
    
    private let tableView: UITableView
    
    //Initializer takes tableView to update and data context, builds a fetch request to retrieve Items, executes the initial fetch then keeps in sync with the tableView via the delegate methods
    init(managedObjectContext: NSManagedObjectContext, tableView: UITableView) {
        self.tableView = tableView
        super.init(fetchRequest: Item.fetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        self.delegate = self
        tryFetch()
    }
    
    func tryFetch() {
        do {
            try performFetch()
        } catch {
            print("Unresolved error in DiaryFetchedResultsController: \(error.localizedDescription)")
        }
    }
    
    //MARK: - Fetched Results Controller Delegate:
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move, .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

