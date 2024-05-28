//
//  AlwaysTests.swift
//  GPXWorkshopTests
//
//  Created by Kyuhyun Park on 5/17/24.
//

import XCTest
import Combine

final class AlwaysTests: XCTestCase {

    func testAlwaysPublisher() throws {
        var count = 0
        let _ = AlwaysPublisher(output: 999).prefix(5).sink { value in
            count += 1
            XCTAssertEqual(value, 999)
            XCTAssertTrue(count <= 5)
        }
        XCTAssertEqual(count, 5)
    }

    func testAlwaysSequence() throws {
        var count = 0
        AlwaysSequence(output: 999).prefix(5).forEach { value in
            count += 1
            XCTAssertEqual(value, 999)
            XCTAssertTrue(count <= 5)
        }
        XCTAssertEqual(count, 5)
    }

}
