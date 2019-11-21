//
//  LocationSaverDelegate.swift
//  DiaryApp
//
//  Created by Gavin Butler on 20-11-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

//Item Detail controller must conform to this in order to pass the location coordinate back from the map controller to the detail controller.
protocol LocationSaverDelegate: class {
    func saveLocation(at: Coordinate)
}
