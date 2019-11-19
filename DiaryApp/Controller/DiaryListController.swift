//
//  DiaryListController.swift
//  DiaryApp
//
//  Created by Gavin Butler on 26-10-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit
import CoreData

class DiaryListController: UITableViewController {

    let managedObjectContext = CoreDataStack().managedObjectContext
    
    lazy var dataSource: DataSource = {
        return DataSource(tableView: self.tableView, context: self.managedObjectContext)
    }()
    
    lazy var headerView: UITableViewCell = {
        let cell = Bundle.main.loadNibNamed("HeaderCell", owner: self, options: nil)?.first as! HeaderCell
        cell.dateLabel.text = Date().formattedMmmDDYYYY()
        return cell
    }()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        
        configureUI()
        
    }
    
    //MARK: - Table View Delegate Methods:
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let detailViewController = segue.destination as? DetailViewController else { return }
        
        detailViewController.context = self.managedObjectContext
        
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let item = dataSource.object(at: indexPath)
                detailViewController.item = item

            }
        }
    }
    
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
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(DiaryListController.refreshSearchResults))
        
        tableView.tableHeaderView = searchController.searchBar
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
    }
    
    @objc func refreshSearchResults() {
        //self.dismiss(animated: true, completion: nil)
        
    }
    
}

extension DiaryListController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        print("searchbar text is: \(searchController.searchBar.text!)")
        
        self.dataSource.fetchedResultsController.fetchRequest.predicate = nil
        
        if !searchController.searchBar.text!.isEmpty {
            self.dataSource.fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "text CONTAINS[cd] %@", searchController.searchBar.text!)
        }
        
        self.dataSource.fetchedResultsController.tryFetch()
        
        tableView.reloadData()
    }
    
}
