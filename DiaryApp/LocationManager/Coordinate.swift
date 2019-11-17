//
//  Coordinate.swift
//  DiaryApp
//
//  Created by Gavin Butler on 16-11-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation
import CoreLocation

struct Coordinate {
    let latitude: Double
    let longitude: Double
}

extension Coordinate: JSONDecodable {
    init?(json: [String : Any]) {
        guard let latitudeValue = json["latitude"] as? Double, let longitudeValue = json["longitude"] as? Double else { return nil }
        self.latitude = latitudeValue
        self.longitude = longitudeValue
    }
}

extension Coordinate {
    init(location: CLLocation) {
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }
}
