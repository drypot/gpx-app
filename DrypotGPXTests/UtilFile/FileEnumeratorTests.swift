//
//  FileEnumeratorTests.swift
//  DrypotGPXTests
//
//  Created by Kyuhyun Park on 5/15/24.
//

import XCTest

final class FileEnumeratorTests: XCTestCase {

    func testEnumerateFiles() throws {
        let baseUrl = URL(fileURLWithPath: defaultGPXFolderPath)
        var count = 0
        let limit = 5
        
        let result = enumerateFiles(at: baseUrl) { url in
            count += 1
            if count < limit {
                return .success(true)
            } else {
                return .success(false)
            }
        }
        
        switch result {
        case .success:
            XCTAssertEqual(count, 5)
        case .failure:
            XCTFail()
        }
    }

}
