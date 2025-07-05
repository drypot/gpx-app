//
//  FixtureURLTests.swift
//  ModelTests
//
//  Created by Kyuhyun Park on 6/7/24.
//

import Foundation
import Testing

struct FixtureURLTests {

    func fixtureURL(_ fixture: String) -> URL {
        return URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .appendingPathComponent("Fixtures")
            .appendingPathComponent(fixture)
    }

    @Test
    func test() throws {
        #expect(fixtureURL("dummy1.txt").absoluteString.hasSuffix("ModelTests/_Utility/Fixtures/dummy1.txt"))
        #expect(fixtureURL("Sub1/dummy3.txt").absoluteString.hasSuffix("ModelTests/_Utility/Fixtures/Sub1/dummy3.txt"))
    }

    @Test
    func testAbc() async throws {

    }

}
