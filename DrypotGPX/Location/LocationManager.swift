//
//  LocationManager.swift
//  DrypotGPX
//
//  Created by drypot on 2024-04-13.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    
    private var manager: CLLocationManager
    
    @Published private(set) var currentLocation: CLLocation?
    @Published private(set) var authorizationStatus: CLAuthorizationStatus
    
    init(manager: CLLocationManager = CLLocationManager()) {
        self.manager = manager
        self.authorizationStatus = manager.authorizationStatus
        super.init()
        manager.delegate = self
    }
    
    func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        manager.requestLocation()
    }

    func startMonitoringLocation() {
        manager.startUpdatingLocation()
    }
    
    func stopMonitoringLocation() {
        manager.stopUpdatingLocation()
    }

}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("LocationManager: ", terminator: "")
        switch status {
        case .notDetermined:
            print("not determined")
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        case .authorizedAlways, .authorizedWhenInUse:
            print("authorized")
        @unknown default:
            print("auth unknown")
        }
        self.authorizationStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        print("LocationManager: ", terminator: "")
        if let location {
            print("\(location.coordinate.latitude) \(location.coordinate.longitude)")
        } else {
            print("nil")
        }
        self.currentLocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager: \(error)")
    }
    
}
