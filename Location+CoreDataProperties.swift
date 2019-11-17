//
//  Location+CoreDataProperties.swift
//  DiaryApp
//
//  Created by Gavin Butler on 17-11-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }
    
    static var entityName: String {
        return String(describing: Location.self)
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var item: Item?

}

extension Location {
    
    func asCoordinate() -> Coordinate {
        return Coordinate(latitude: self.latitude, longitude: self.longitude)
    }
}
