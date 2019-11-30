//
//  DiaryListController.swift
//  DiaryApp
//
//  Created by Gavin Butler on 26-10-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit
import CoreData

//Displays main tableview showing list of items
class DiaryListController: UITableViewController {

    //Set the context for CRUD operations – need to ensure this specific context is used by any other controllers wishing to retrieve or modify data
    let managedObjectContext = CoreDataStack.shared.managedObjectContext
    
    lazy var dataSource: DataSource = {
        return DataSource(tableView: self.tableView, context: self.managedObjectContext)
    }()
    
    //Header view to display today’s date
    lazy var headerView: UITableViewCell = {
        let cell = Bundle.main.loadNibNamed("HeaderCell", owner: self, options: nil)?.first as! HeaderCell
        cell.dateLabel.text = Date().formattedMmmDDYYYY()
        return cell
    }()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Set tableView datasource and self as search delegate
        tableView.dataSource = dataSource
        dataSource.fetchedResultsController.delegate = self
        
        do {
            try dataSource.fetchedResultsController.performFetch()
        } catch {
            presentAlert(with: "Error", message: error.localizedDescription)
        }
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.backgroundColor = .white
        searchController.searchBar.placeholder = "Enter search term"
        
        definesPresentationContext = true
        navigationItem.searchController = searchController

        searchController.searchBar.delegate = self
        
        //ViewController title and navigation bar item configurations
        configureUI()
        
    }
    
    //MARK: - Table View Delegate Methods:
    
    //Allow swipe to delete on the tableView rows
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Should only be segueing to the detail VC here.
        guard let detailViewController = segue.destination as? DetailViewController else { return }
        
        //Set context and item using selected tableView row (dependency injection)
//        detailViewController.context = self.managedObjectContext
        
        if segue.identifier == "showDetail" {   //Need to set the item
            if let indexPath = tableView.indexPathForSelectedRow {
                let item = dataSource.fetchedResultsController.object(at: indexPath)
                detailViewController.item = item
            }
        }
    }
    
    //TableView delegate methods to establish header view
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(70)
    }
    
}

//MARK: - Helper Methods
extension DiaryListController {
    func configureUI() {
        self.title = Date().formattedMmmDDYYYY()
    }
}

//MARK: - SearchBarController and SearchBar Delegate Methods:
extension DiaryListController: UISearchResultsUpdating, UISearchBarDelegate {
    
    //Delegate method triggered for each entry in the searchbar.  Used as filter passed to the fetchedResultsController via setting it’s predicate.
    func updateSearchResults(for searchController: UISearchController) {
        print("searchbar text is: \(searchController.searchBar.text!)")
        
        //Clear any prior filter (filter should stay removed if user has backspaced to have no text in the searchbar)
        self.dataSource.fetchedResultsController.fetchRequest.predicate = nil
        
        //If you have text, use it as the filter – create & set the predicate
        if !searchController.searchBar.text!.isEmpty {
            self.dataSource.fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "text CONTAINS[cd] %@", searchController.searchBar.text!)
        }
        
        //Fetch data with the new filter, reload the tableView to update the UI
        
        //Always use a do-catch in the view controller so you can present an alert when something went wrong.
        do {
            try self.dataSource.fetchedResultsController.performFetch()
        } catch {
            presentAlert(with: "Error", message: error.localizedDescription)
        }
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Searchbar cancel selected")
        tableView.tableHeaderView = nil
        self.navigationItem.leftBarButtonItem?.isEnabled = true
    }
    
}

//MARK: - Fetched Results Controller Delegate:
extension DiaryListController: NSFetchedResultsControllerDelegate {
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
        //Get rid of the build warning by covering unknown enum cases
        @unknown default: break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
