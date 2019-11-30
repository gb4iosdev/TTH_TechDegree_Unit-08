//
//  CoreDataStack.swift
//  DiaryApp
//
//  Created by Gavin Butler on 26-10-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStack {

    lazy var managedObjectContext: NSManagedObjectContext = {
        let container = self.persistentContainer
        return container.viewContext
    }()
    
    private lazy var persistentContainer: NSPersistentContainer  = {
        let container = NSPersistentContainer (name: "DiaryList")
        container.loadPersistentStores() { storeDescription, error in
            if let error = error as NSError? {
                
                //Inform the user of the failure to load from persisent store, then terminate the app
                DispatchQueue.main.async {
                    AlertManager().generateSimpleAlert(withTitle: "Error", message: error.localizedDescription)
                    fatalError("Error:  Unknown type: \(error), \(error.localizedDescription)")
                }
            }
        }
        return container
    }()
    
}

extension NSManagedObjectContext {
    
    func saveChanges() {
        if self.hasChanges {
            do {
                try save()
            } catch {
                // Present a modal alert to advise that save was not succesful.
                AlertManager().generateSimpleAlert(withTitle: "Error on save", message: error.localizedDescription)
            }
        }
    }
}
