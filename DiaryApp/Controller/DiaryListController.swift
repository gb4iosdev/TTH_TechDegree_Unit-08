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
    
    lazy var fetchedResultsController: DiaryFetchedResultsController = {
        return DiaryFetchedResultsController(managedObjectContext: self.managedObjectContext, tableView: self.tableView)
    }()
    
    lazy var headerView: UITableViewCell = {
        let cell = Bundle.main.loadNibNamed("HeaderCell", owner: self, options: nil)?.first as! HeaderCell
        cell.dateLabel.text = Date().formattedMmmDDYYYY()
        return cell
    }()
    
    
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
        if segue.identifier == "newItem",
        let navigationController = segue.destination as? UINavigationController,
        let addTaskController = navigationController.topViewController as? AddItemController {
            print("This Context: \(self.managedObjectContext.description)")
            addTaskController.managedObjectContext = self.managedObjectContext
        } else if segue.identifier == "showDetail" {
            guard let detailViewController = segue.destination as? DetailViewController,
            let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            let item = dataSource.object(at: indexPath)
            detailViewController.item = item
            detailViewController.context = self.managedObjectContext
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //return ListHeader.view(withWidth: tableView.frame.width)
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
