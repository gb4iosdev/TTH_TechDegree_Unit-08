//
//  LocationMapController.swift
//  DiaryApp
//
//  Created by Gavin Butler on 16-11-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit
import MapKit

//Manages the display of the map view, and passes the user location to the locationSaverDelegate when the user selects save
class LocationMapController: UIViewController {
    
    // MARK: - Properties
    let mapSpanRadius: CLLocationDistance = 5_000
    
    //Update the map whenever the coordinate changes.
    var coordinate: Coordinate? {
        didSet {
            if let coordinate = coordinate {
                adjustMap(with: coordinate)
            }
        }
    }
    
    var locationSaverDelegate: LocationSaverDelegate?

    @IBOutlet weak var mapView: MKMapView!
    
    //Set this view controller as the recipient of location and permission events
    lazy var locationManager: LocationManager = {
        return LocationManager(locationsDelegate: self, permissionsDelegate: self)
    }()
    

    var isAuthorized: Bool {
        return LocationManager.isAuthorized
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //If authorized find location, otherwise request permission
    override func viewDidAppear(_ animated: Bool) {
        if isAuthorized {
            locationManager.requestLocation()
        } else {
            checkPermissions()
        }
    }
    
     //If a co-ordinate has been set, pass it back to the detail view controller to later save if the user saves the item.
    @IBAction func saveLocationPressed(_ sender: UIButton) {
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
    
    //Location found by the CLLocationManager.  Save it and centre the map on it
    func obtainedCoordinates(_ coordinate: Coordinate) {
        self.coordinate = coordinate
        adjustMap(with: coordinate)
    }
    
    //Simply print the error for now if there is a failure
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

extension LocationMapController {
    
    //Centre the map using the passed in coordinate
    func adjustMap(with coordinate: Coordinate) {
        mapView?.setRegion(around: coordinate, withSpan: mapSpanRadius)
    }
}



