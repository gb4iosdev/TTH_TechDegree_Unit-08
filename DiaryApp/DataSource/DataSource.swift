//
//  DataSource.swift
//  DiaryApp
//
//  Created by Gavin Butler on 26-10-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit
import CoreData

class DataSource: NSObject, UITableViewDataSource {
    
    private let tableView: UITableView
    private let context: NSManagedObjectContext
    
    //Essentially the datasource for this datasource!, and the link to the Core Data objects
//    lazy var fetchedResultsController: DiaryFetchedResultsController = {
//        return DiaryFetchedResultsController(managedObjectContext: self.context, tableView: self.tableView)
//    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Item> = {
        let frc = NSFetchedResultsController(fetchRequest: Item.fetchRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        return frc
    }()
    
    init(tableView: UITableView, context: NSManagedObjectContext) {
        self.tableView = tableView
        self.context = context
    }
    
    //This one is kinda unnecessary, isn't it?
//    func object(at indexPath: IndexPath) -> Item {
//        return fetchedResultsController.object(at: indexPath)
//    }
    
    //MARK: - Table View DataSource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? ItemCell else { return UITableViewCell() }
        
        cell.configure(with: fetchedResultsController.object(at: indexPath))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let item = fetchedResultsController.object(at: indexPath)
        context.delete(item)
        context.saveChanges()
    }
    
    //This should be part of the ItemCell class. Views should always update themselves.
    //Set the cell data based on the item.  Also, display the dateLabel on a cell if it is older than today.
//    private func configuredCell(_ cell: ItemCell, at indexPath: IndexPath) -> UITableViewCell {
//        let item = fetchedResultsController.object(at: indexPath)
//        cell.title.text = item.text
//        cell.detail.text = item.detailedText
//        if dayNumber(for: item.creationDateAsDate()) != dayNumber(for: Date()) {
//            cell.dateLabel.text = item.creationDateAsDate().formattedMmmDDYYYY()
//        }
//        return cell
//    }
}

//MARK:- Helper Methods

extension Date {
    //Returns the rounded down number of days since an unimportant reference date
    func dayNumber() -> Int {
        return Int(self.timeIntervalSinceReferenceDate/(60*60*24))
    }
}
