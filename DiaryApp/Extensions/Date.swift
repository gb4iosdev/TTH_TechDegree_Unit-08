//
//  Date.swift
//  DiaryApp
//
//  Created by Gavin Butler on 09-11-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import Foundation

extension Date {
//Functions for commonly used date formats:
    
    func formattedMmmDDYYYY() -> String {
        let format = DateFormatter()
        format.dateFormat = "MMM dd, YYYY HH:mm"
        return format.string(from: self)
    }
    
}
