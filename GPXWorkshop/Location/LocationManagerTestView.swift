//
//  LocationManagerTestView.swift
//  GPXWorkshop
//
//  Created by drypot on 2024-04-14.
//

import SwiftUI
import Combine
import CoreLocation

struct LocationManagerTestView: View {
    
    @State var model = LocationManagerTestModel()
    
    var body: some View {
        Text("Test LocationManager")
        Button("request current location") {
            model.requestLocation()
        }
    }
    
}

class LocationManagerTestModel {
    
    private var manager: LocationManager = LocationManager()
    private var cancelables = Set<AnyCancellable>()

    init() {
        manager.$currentLocation.sink(receiveValue: locationUpdated).store(in: &cancelables)
        manager.$authorizationStatus.sink(receiveValue: authUpdated).store(in: &cancelables)
    }

    func requestLocation() {
        manager.requestAuthorization()
        manager.requestLocation()
    }
    
    private func locationUpdated(location: CLLocation?) {
        print("location subscriber: ", terminator: "")
        if let location {
            print("\(location.coordinate.latitude) \(location.coordinate.longitude)")
        } else {
            print("nil")
        }
    }
    
    private func authUpdated(status: CLAuthorizationStatus) {
        print("auth status subscriber: ", terminator: "")
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
    }

}

#Preview {
    LocationManagerTestView()
}
