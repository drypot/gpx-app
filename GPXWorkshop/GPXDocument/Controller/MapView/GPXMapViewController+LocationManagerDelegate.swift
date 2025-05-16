//
//  GPXMapViewController+LocationManagerDelegate.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 5/16/25.
//

import Cocoa
import MapKit
import GPXWorkshopSupport

extension GPXMapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locationManager didUpdateLocations 1")
        guard let location = locations.last else { return }

        print("locationManager didUpdateLocations 2")
        if document?.allGPXCaches.isEmpty == true {
            print("locationManager didUpdateLocations 3")
            let region = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: 50_000,
                longitudinalMeters: 50_000
            )
            self.mapView.setRegion(region, animated: false)
        }

        // 위치 한 번 받고 멈춤
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager didFailWithError: \(error)")
    }

}
