//
//  PublisherTests.swift
//  ModelTests
//
//  Created by drypot on 2024-02-12.
//

import Combine
import Testing
@testable import Model

struct PublisherTests {

    @Test func testAsResult() async throws {
        var result: Result<String, Never>?

        let cancellable = Just("abc")
            .asResult()
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        result = .failure(error)
                    }
                },
                receiveValue: { value in
                    result = value
                }
            )
        cancellable.cancel()
        
        let value = result?.get()

        #expect(value == "abc")
    }
    
}
