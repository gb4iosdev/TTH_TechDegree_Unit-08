//
//  Item+CoreDataProperties.swift
//  DiaryApp
//
//  Created by Gavin Butler on 28-10-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//
//

import Foundation
import CoreData


extension Item {

    @NSManaged public var isComplete: Bool
    @NSManaged public var text: String
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        let request = NSFetchRequest<Item>(entityName: "Item")
        request.sortDescriptors = [NSSortDescriptor(key: "text", ascending: true)]
        return request
    }
    

}
