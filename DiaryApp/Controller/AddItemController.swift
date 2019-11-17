//
//  AddItemController.swift
//  DiaryApp
//
//  Created by Gavin Butler on 28-10-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit
import CoreData

class AddItemController: UIViewController {

    var managedObjectContext: NSManagedObjectContext!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AddTaskController Context: \(managedObjectContext.description)")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        guard let text = textField.text, !text.isEmpty else { return }
        
        let item = NSEntityDescription.insertNewObject(forEntityName: "Item", into: managedObjectContext) as! Item
        
        item.text = text                 //item has been saved to the managedContext scratch pad only at this point.  Still not persisted.
        item.creationDate = Date() as NSDate
        item.detailedText = Date().formattedMmmDDYYYY()
        
        managedObjectContext.saveChanges()
        
        dismiss(animated: true, completion: nil)
        
    }
    

}
