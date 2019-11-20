//
//  MKMapView.swift
//  DiaryApp
//
//  Created by Gavin Butler on 20-11-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import MapKit

extension MKMapView {
    
    func setRegion(around coordinate: Coordinate, withSpan span: Double) {
        let span = MKCoordinateRegion(center: coordinate.twoDimensional(), latitudinalMeters: span, longitudinalMeters: span).span
        let region = MKCoordinateRegion(center: coordinate.twoDimensional(), span: span)
        self.setRegion(region, animated: true)
    }
}



