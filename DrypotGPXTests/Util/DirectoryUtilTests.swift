//
//  FileManagerEnumeratorTests.swift
//  DrypotGPXTests
//
//  Created by Kyuhyun Park on 5/15/24.
//

import XCTest

final class DirectoryUtilTests: XCTestCase {

    func testEnumerateRegualrFiles() throws {
        let baseUrl = URL(fileURLWithPath: "Documents/GPX Files")
        enumerateRegularFiles(at: baseUrl, limit: 5) { url in
            print(url)
        }
    }

}
