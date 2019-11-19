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
    @NSManaged public var creationDate: NSDate
    @NSManaged public var detailedText: String?
    @NSManaged public var photos: Set<Photo>
    @NSManaged public var location: Location?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        let request = NSFetchRequest<Item>(entityName: "Item")
        request.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return request
    }
}

extension Item {
    
    func creationDateAsDate() -> Date {
        return self.creationDate as Date
    }
    
    
}
