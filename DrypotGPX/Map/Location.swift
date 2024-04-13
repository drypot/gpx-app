//
//  Location.swift
//  DrypotGPX
//
//  Created by drypot on 2024-04-13.
//

import Foundation
import CoreLocation

class CurrentLocation: NSObject {
  
  let locationManager: CLLocationManager
  
  override init() {
    locationManager = CLLocationManager()
    super.init()
    locationManager.delegate = self
  }
  
  func run() {
    locationManager.requestWhenInUseAuthorization()
    locationManager.requestLocation()
  }
}

extension CurrentLocation: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    //location5
    switch status {
    case .authorizedAlways, .authorizedWhenInUse:
      print("GPS 권한 설정됨")
      self.locationManager.startUpdatingLocation() // 중요!
    case .restricted, .notDetermined:
      print("GPS 권한 설정되지 않음")
      //getLocationUsagePermission()
    case .denied:
      print("GPS 권한 요청 거부됨")
      //getLocationUsagePermission()
    default:
      print("GPS: Default")
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let currentLocation = locations[locations.count-1]
    print("위도 : \(currentLocation.coordinate.latitude) / 경도 : \(currentLocation.coordinate.longitude)")
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    print("방위 : \(newHeading.magneticHeading)")
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }
  
}
