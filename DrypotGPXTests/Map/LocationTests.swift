//
//  LocationTests.swift
//  DrypotGPXTests
//
//  Created by drypot on 2024-04-13.
//

import XCTest
import CoreLocation

final class LocationTests: XCTestCase {
  
  func testExample() throws {
    let locationManager = CLLocationManager()
    locationManager.requestWhenInUseAuthorization()
  }
  
}
