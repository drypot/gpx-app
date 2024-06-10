//
//  FileEnumeratorTests.swift
//  GPXWorkshopTests
//
//  Created by Kyuhyun Park on 5/15/24.
//

import XCTest
import Combine

final class FileEnumeratorTests: XCTestCase {

    func testFilesSequence() throws {
        let url = fixtureURL("Sub1")
        let fixtures = [
            "Fixtures/Sub1/dummy3.txt",
            "Fixtures/Sub1/dummy4.txt"
        ]
        var count = 0
        Files(url: url).forEach { url in
            count += 1
            let contains = fixtures.reduce(0) { $0 + (url.absoluteString.contains($1) ? 1 : 0) }
            XCTAssertEqual(contains, 1)
        }
        XCTAssertEqual(count, 2)
    }

    func testFilesSequence2() throws {
        let urls = [
            fixtureURL("dummy1.txt"),
            fixtureURL("Sub1")
        ]
        let fixtures = [
            "Fixtures/dummy1.txt",
            "Fixtures/Sub1/dummy3.txt",
            "Fixtures/Sub1/dummy4.txt"
        ]
        var count = 0
        Files(urls: urls).forEach { url in
            count += 1
            let contains = fixtures.reduce(0) { $0 + (url.absoluteString.contains($1) ? 1 : 0) }
            XCTAssertEqual(contains, 1)
        }
        XCTAssertEqual(count, 3)
    }

    func testFilesSequence3() throws {
        let urls = [
            fixtureURL(""),
        ]
        let fixtures = [
            "Fixtures/dummy1.txt",
            "Fixtures/dummy2.txt",
            "Fixtures/Sub1/dummy3.txt",
            "Fixtures/Sub1/dummy4.txt"
        ]
        var count = 0
        Files(urls: urls).forEach { url in
            count += 1
            let contains = fixtures.reduce(0) { $0 + (url.absoluteString.contains($1) ? 1 : 0) }
            XCTAssertEqual(contains, 1)
        }
        XCTAssertEqual(count, 4)
    }

    func testEnumerateFiles() throws {
        let baseUrl = URL(fileURLWithPath: defaultGPXFolderPath)
        var count = 0
        let limit = 5
        
        let result = enumerateFiles(url: baseUrl) { url in
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

    func testFilesPublisher() throws {
        let baseURL = URL(fileURLWithPath: defaultGPXFolderPath)
        var count = 0
        
        let _ = FilesPublisher(url: baseURL).prefix(5).sink { url in
            count += 1
            //print(url)
            XCTAssertTrue(count <= 5)
        }
        XCTAssertEqual(count, 5)
    }

}
