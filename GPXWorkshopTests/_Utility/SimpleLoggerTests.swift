//
//  ActorLoggerTests.swift
//  HelloSwiftFrameworkTests
//
//  Created by Kyuhyun Park on 11/28/24.
//

import Foundation
import Testing

struct SimpleLoggerTests {

    @Test func test() async throws {
        let logger = SimpleLogger<Int>()

        logger.append(1)

        await Task {
            logger.append(2)
        }.value

        logger.append(3)

        #expect(logger.result() == [1, 2, 3])
    }

}
