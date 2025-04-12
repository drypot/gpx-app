//
//  FileEnumeratorTests.swift
//  ModelTests
//
//  Created by Kyuhyun Park on 5/15/24.
//

import Foundation
import Testing
@testable import Model

struct FileEnumeratorTests {

    func fixtureURL(_ fixture: String) -> URL {
        return URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .appendingPathComponent("Fixtures")
            .appendingPathComponent(fixture)
    }

    @Test func testFilesSequence() throws {
        let url = fixtureURL("Sub1")
        let fixtures = [
            "Fixtures/Sub1/dummy3.txt",
            "Fixtures/Sub1/dummy4.txt"
        ]
        var count = 0
        Files(url: url).forEach { url in
            count += 1
            let contains = fixtures.reduce(0) { $0 + (url.absoluteString.contains($1) ? 1 : 0) }
            #expect(contains == 1)
        }
        #expect(count == 2)
    }

    @Test func testFilesSequence2() throws {
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
            #expect(contains == 1)
        }
        #expect(count == 3)
    }

    @Test func testFilesSequence3() throws {
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
            #expect(contains == 1)
        }
        #expect(count == 4)
    }

    @Test func testEnumerateFiles() throws {
        let baseUrl = fixtureURL("")
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
            #expect(count == 4)
        case .failure:
            fatalError()
        }
    }

    @Test func testFilesPublisher() throws {
        let baseURL = fixtureURL("")
        var count = 0
        
        let _ = FilesPublisher(url: baseURL).sink { url in
            count += 1
            #expect(count <= 5)
        }
        #expect(count == 4)
    }

}
