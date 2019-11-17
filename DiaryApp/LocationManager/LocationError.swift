//
//  LocationError.swift
//  DiaryApp
//
//  Created by Gavin Butler on 16-11-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

enum LocationError: Error {
    case unknownError
    case disallowedByUser
    case unableToFindLocation
}
