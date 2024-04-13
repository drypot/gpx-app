//
//  CurrentLocation.swift
//  DrypotGPX
//
//  Created by drypot on 2024-04-13.
//

import Foundation
import CoreLocation

//
// CoreLocation 쓰려면 프로젝트 세팅을 해줘야 한다.
// Project -> Targets -> Signing & Capabilities -> App Sanbox -> App Data -> Location 체크
//
// MapKit 으로 지도 보려면 추가 세팅.
// Project -> Targets -> Signing & Capabilities -> App Sanbox -> Network -> Outgoing Connections (Client) 체크
//

// https://developer.apple.com/documentation/corelocation/cllocationmanager/1620548-requestlocation
// requestLocation 은 로케이션을 한번만 받고 서비스를 죽인다.
// 반복 호출한다고 델리게이트가 반복 반응하지 않는다.
//
// 하지만 requestLocation 한번 호출에 델리게이트가 3번 연달아 호출될 때도 있었고,
// 두번째 불렀을 때도 호출될 때도 있고,
// 반응이 없을 때도 있었다,
//

class CurrentLocation: NSObject {
  
  var manager: CLLocationManager?
  
  override init() {
    super.init()
  }

  func request() {
    manager = CLLocationManager()
    manager!.delegate = self
    manager!.requestWhenInUseAuthorization()
    manager!.requestLocation()
  }
  
  func log(_ s: String) {
    print("Current Location: \(s)")
  }
  
  func printCurrent() {
    guard let location = manager?.location else {
      log("unknown")
      return
    }
    log("\(location.coordinate.latitude) \(location.coordinate.longitude)")
  }

}

extension CurrentLocation: CLLocationManagerDelegate {
  
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
    log("\(location.coordinate.latitude) \(location.coordinate.longitude)")
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    log("heading: \(newHeading.magneticHeading)")
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    log("error: \(error)")
  }
}
