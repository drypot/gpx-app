//
//  LocationManagerTestView.swift
//  DrypotGPX
//
//  Created by drypot on 2024-04-14.
//

import SwiftUI
import Combine
import CoreLocation

struct LocationManagerTestView: View {
    
    @State var manager: LocationManager = LocationManager()
    
    init() {
        let _ = manager.$currentLocation.sink(receiveValue: printLocation)
        let _ = manager.$authorizationStatus.sink(receiveValue: printAuthStatus)
    }
    
    var body: some View {
        Text("Test LocationManager")
        Button("request current location") {
            manager.requestAuthorization()
            manager.requestLocation()
        }
        Button("print current location") {
            printLocation(location: manager.currentLocation)
        }
        Button("print auth status") {
            printAuthStatus(status: manager.authorizationStatus)
        }
    }

    func printLocation(location: CLLocation?) {
        guard let location else { return }
        print("location: \(location.coordinate.latitude) \(location.coordinate.longitude)")
    }
    
    func printAuthStatus(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("not determined")
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        case .authorizedAlways, .authorizedWhenInUse:
            print("authorized")
        default:
            print("auth unknown")
        }
    }
    
}

#Preview {
    LocationManagerTestView()
}
