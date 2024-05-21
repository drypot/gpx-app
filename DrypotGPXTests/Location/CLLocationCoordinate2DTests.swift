//
//  CLLocationCoordinate2DTests.swift
//  DrypotGPXTests
//
//  Created by Kyuhyun Park on 5/21/24.
//

import XCTest
import CoreLocation

final class CLLocationCoordinate2DTests: XCTestCase {

    func testDistance() throws {
        let a = CLLocationCoordinate2D(latitude: 37.5322025, longitude: 127.0606153)
        let b = CLLocationCoordinate2D(latitude: 37.5313079, longitude: 127.0638316)
        let d = a.distance(from: b)
        
        let a2 = CLLocation(latitude: a.latitude, longitude: a.longitude)
        let b2 = CLLocation(latitude: b.latitude, longitude: b.longitude)
        let d2 = a2.distance(from: b2)
        
        XCTAssertEqual(d, d2, accuracy: 1e-0)
    }

}
