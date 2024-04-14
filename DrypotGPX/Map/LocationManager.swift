//
//  CurrentLocation.swift
//  DrypotGPX
//
//  Created by drypot on 2024-04-13.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject {
    
    private var manager: CLLocationManager
    
    @Published private(set) var currentLocation: CLLocation?
    @Published private(set) var authorizationStatus: CLAuthorizationStatus
    
    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.manager = locationManager
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

    func log(_ s: String) {
        print("LocationManager: \(s)")
    }
    
    func logLocation() {
        guard let location = manager.location else { return log("current: unknown") }
        log("current: \(location.coordinate.latitude) \(location.coordinate.longitude)")
    }
    
    func logAuthStatus() {
        switch manager.authorizationStatus {
        case .notDetermined:
            log("not determined")
        case .restricted:
            log("restricted")
        case .denied:
            log("denied")
        case .authorizedAlways, .authorizedWhenInUse:
            log("authorized")
        default:
            log("auth unknown")
        }
    }

}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last!
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        log("error: \(error)")
    }
    
}
