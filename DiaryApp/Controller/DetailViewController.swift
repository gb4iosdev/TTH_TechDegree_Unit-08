//
//  DetailViewController.swift
//  DiaryApp
//
//  Created by Gavin Butler on 28-10-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    var item: Item?
    var context: NSManagedObjectContext!
    
    @IBOutlet weak var detailTextField: UITextField!
    
    override func viewDidLoad() {
        if let item = item {
            detailTextField.text = item.text
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if let item = item, let newText = detailTextField.text {
            item.text = newText
            context.saveChanges()
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        if let item = item {
            context.delete(item)
            context.saveChanges()
            navigationController?.popViewController(animated: true)
        }
    }
    
    
}
