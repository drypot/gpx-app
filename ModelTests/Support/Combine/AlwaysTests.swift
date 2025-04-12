//
//  AlwaysTests.swift
//  ModelTests
//
//  Created by Kyuhyun Park on 5/17/24.
//

import Combine
import Testing
@testable import Model

struct AlwaysTests {

    @Test func testAlwaysPublisher() throws {
        var count = 0
        let _ = AlwaysPublisher(output: 999).prefix(5).sink { value in
            count += 1
            #expect(value == 999)
            #expect(count <= 5)
        }
        #expect(count == 5)
    }

    @Test func testAlwaysSequence() throws {
        var count = 0
        AlwaysSequence(output: 999).prefix(5).forEach { value in
            count += 1
            #expect(value == 999)
            #expect(count <= 5)
        }
        #expect(count == 5)
    }

}
