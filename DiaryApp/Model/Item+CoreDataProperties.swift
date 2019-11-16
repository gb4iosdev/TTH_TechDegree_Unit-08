//
//  Item+CoreDataProperties.swift
//  DiaryApp
//
//  Created by Gavin Butler on 28-10-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//
//

import UIKit
import CoreData


extension Item {

    @NSManaged public var isComplete: Bool
    @NSManaged public var text: String
    @NSManaged public var detailedText: String?
    @NSManaged public var photos: Set<Photo>
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        let request = NSFetchRequest<Item>(entityName: "Item")
        request.sortDescriptors = [NSSortDescriptor(key: "text", ascending: true)]
        return request
    }
}

extension Item {
    
//    @nonobjc class func withId(_ itemId: UUID, in context: NSManagedObjectContext) -> Item {
//        
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "Id == %@", itemId)
//        request.predicate = predicate
//    }
    
    
    
    
}
