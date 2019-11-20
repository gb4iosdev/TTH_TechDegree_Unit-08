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
    let managedObjectContext = CoreDataStack().managedObjectContext
    
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
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.backgroundColor = .white
        searchController.searchBar.placeholder = "Enter search term"
        
        definesPresentationContext = true
        navigationItem.searchController = searchController
//
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
        guard segue.identifier == "showDetail", let detailViewController = segue.destination as? DetailViewController else { return }
        
        //Set context and item using selected tableView row (dependency injection)
        detailViewController.context = self.managedObjectContext
        if let indexPath = tableView.indexPathForSelectedRow {
            let item = dataSource.object(at: indexPath)
            detailViewController.item = item
        }
        
        //searchController.isActive = false
        //searchController.searchBar.isHidden = true
        
        //tableView.tableHeaderView = nil
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
        
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(DiaryListController.showSearchBar))
//        self.navigationItem.leftBarButtonItem?.isEnabled = true
    }
    
//    @objc func showSearchBar() {
//        //Show the search bar when user selects the search symbol (navbar left item).
//        //tableView.tableHeaderView = searchController.searchBar
//        navigationItem.searchController = searchController
//        searchController.dimsBackgroundDuringPresentation = false
//        searchController.searchResultsUpdater = self
//        definesPresentationContext = true
//    }
    
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
        self.dataSource.fetchedResultsController.tryFetch()
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Searchbar cancel selected")
        tableView.tableHeaderView = nil
        self.navigationItem.leftBarButtonItem?.isEnabled = true
    }
    
}
