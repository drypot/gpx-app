//
//  CurrentLocation.swift
//  DrypotGPX
//
//  Created by drypot on 2024-04-13.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    
    var manager: CLLocationManager = .init()
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }
    
    func log(_ s: String) {
        print("LocationManager: \(s)")
    }
    
    func logCurrent() {
        guard let location = manager.location else {
            log("unknown")
            return
        }
        log("current: \(location.coordinate.latitude) \(location.coordinate.longitude)")
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            log("authorized")
        case .restricted, .notDetermined:
            log("restricted")
        case .denied:
            log("denied")
        default:
            log("authorization changed")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        log("updated: \(location.coordinate.latitude) \(location.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        log("heading: \(newHeading.magneticHeading)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        log("error: \(error)")
    }
    
}
