//
//  PublisherTests.swift
//  DrypotGPXTests
//
//  Created by drypot on 2024-02-12.
//

import Combine
import XCTest

final class PublisherTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func AssertSuccess<Success, Failure>(result: Result<Success, Failure>, value: Success) {
        
    }
    
    func testAsResult() throws {
        var result: Result<String, Never>?
        let expect = self.expectation(description: "expect result")
        
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
                    expect.fulfill()
                },
                receiveValue: { value in
                    result = value
                }
            )
        
        waitForExpectations(timeout: 3)
        cancellable.cancel()
        
        let value = try result?.get()
        
        XCTAssertEqual(value, "abc")
    }
    
}
