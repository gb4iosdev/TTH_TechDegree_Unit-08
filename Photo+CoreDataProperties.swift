//
//  Photo+CoreDataProperties.swift
//  DiaryApp
//
//  Created by Gavin Butler on 15-11-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//
//

import UIKit
import CoreData


extension Photo {
    
    @NSManaged public var image: NSData?
    @NSManaged public var item: Item?

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }
    
    static var entityName: String {
        return String(describing: Photo.self)
    }

    class func with(image: UIImage, to item: Item, in context: NSManagedObjectContext) -> Photo {
        let photo = NSEntityDescription.insertNewObject(forEntityName: Photo.entityName, into: context) as! Photo
        return photo
    }

}
