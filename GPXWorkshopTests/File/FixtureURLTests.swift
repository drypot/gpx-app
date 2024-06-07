//
//  FixtureURLTests.swift
//  GPXWorkshopTests
//
//  Created by Kyuhyun Park on 6/7/24.
//

import XCTest

final class FixtureURLTests: XCTestCase {

    func test() throws {
        XCTAssertTrue(fixtureURL("dummy1.txt").absoluteString.hasSuffix("GPXWorkshopTests/File/Fixtures/dummy1.txt"))
        XCTAssertTrue(fixtureURL("Sub1/dummy3.txt").absoluteString.hasSuffix("GPXWorkshopTests/File/Fixtures/Sub1/dummy3.txt"))
    }


}
