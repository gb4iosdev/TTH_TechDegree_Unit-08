//
//  LocationMapController.swift
//  DiaryApp
//
//  Created by Gavin Butler on 16-11-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit
import MapKit

protocol LocationSaverDelegate: class {
    func saveLocation(at: Coordinate)
}

class LocationMapController: UIViewController {
    
    // MARK: - Properties
    let mapSpanRadius: CLLocationDistance = 5_000
    
    var coordinate: Coordinate? {
        didSet {
            if let coordinate = coordinate {
                adjustMap(with: coordinate)
            }
        }
    }
    
    var locationSaverDelegate: LocationSaverDelegate?

    @IBOutlet weak var mapView: MKMapView!
    
    lazy var locationManager: LocationManager = {
        return LocationManager(locationsDelegate: self, permissionsDelegate: self)
    }()
    

    var isAuthorized: Bool {
        return LocationManager.isAuthorized
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        if isAuthorized {
            locationManager.requestLocation()
        } else {
            checkPermissions()
        }
    }
    
    @IBAction func saveLocationPressed(_ sender: UIButton) {
        print("Save location button pressed")
        if let coordinate = self.coordinate {
            locationSaverDelegate?.saveLocation(at: coordinate)
        }
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    // MARK: - Permissions
    
    /// Checks if the user has authorized location access for whenInUse tracking.
    func checkPermissions() {
        
        do {
            try locationManager.requestLocationAuthorization()
        } catch LocationError.disallowedByUser {
            //  Show an alert to users
            launchAlert()
        } catch let error {
            print("Location Authorization Error: \(error.localizedDescription)")
        }
    }
    
    func launchAlert() {
        let alertController = UIAlertController (title: "Location Permissions have been denied by user", message: "Go to Settings?", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Location Manager Delegate
extension LocationMapController: LocationManagerDelegate {
    func obtainedCoordinates(_ coordinate: Coordinate) {
        self.coordinate = coordinate
        adjustMap(with: coordinate)
    }
    
    func failedWithError(_ error: LocationError) {
        print(error)
    }
}

// MARK: - Location Permissions Delegate:

extension LocationMapController: LocationPermissionsDelegate {
    func authorizationSucceeded() {
        print("LOCATION AUTHORIZATION GRANTED")
    }
    
    func authorizationFailedWithStatus (_ status: CLAuthorizationStatus) {
        launchAlert()
    }
}


//// MARK: - Map Functions
//
//extension LocationMapController {
//    func updateUserLocation(for searchController: UISearchController) {
//        guard let coordinate = coordinate else { return }
//
//        self.mapView.removeAnnotations(self.mapView.annotations)
//        let point = MKPointAnnotation()
//        point.coordinate = CLLocationCoordinate2D(latitude: .init(floatLiteral: 60.4), longitude: .init(floatLiteral: 120.2))
//        self.mapView.addAnnotation(point)
//    }
//}

// MARK: - MapKit
extension LocationMapController {
    func adjustMap(with coordinate: Coordinate) {
        print("Adjusting map with coord lat: \(coordinate.latitude) & long: \(coordinate.longitude)")
        let coordinate2D = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let span = MKCoordinateRegion(center: coordinate2D, latitudinalMeters: mapSpanRadius, longitudinalMeters: mapSpanRadius).span
        let region = MKCoordinateRegion(center: coordinate2D, span: span)
        mapView?.setRegion(region, animated: true)
    }
}



