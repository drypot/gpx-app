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

        let files = Files(url: url).sorted(by: { $0.path < $1.path })

        #expect(files.count == 2)

        #expect(files[0].absoluteString.hasSuffix("Fixtures/Sub1/dummy3.txt"))
        #expect(files[1].absoluteString.hasSuffix("Fixtures/Sub1/dummy4.txt"))
    }

    @Test func testFilesSequence2() throws {
        let urls = [
            fixtureURL("dummy1.txt"),
            fixtureURL("Sub1")
        ]

        let files = Files(urls: urls).sorted(by: { $0.path < $1.path })

        #expect(files.count == 3)

        #expect(files[0].absoluteString.hasSuffix("Fixtures/Sub1/dummy3.txt"))
        #expect(files[1].absoluteString.hasSuffix("Fixtures/Sub1/dummy4.txt"))
        #expect(files[2].absoluteString.hasSuffix("Fixtures/dummy1.txt"))
    }

    @Test func testFilesSequence3() throws {
        let urls = [
            fixtureURL(""),
        ]

        let files = Files(urls: urls).sorted(by: { $0.path < $1.path })

        #expect(files.count == 4)

        #expect(files[0].absoluteString.hasSuffix("Fixtures/Sub1/dummy3.txt"))
        #expect(files[1].absoluteString.hasSuffix("Fixtures/Sub1/dummy4.txt"))
        #expect(files[2].absoluteString.hasSuffix("Fixtures/dummy1.txt"))
        #expect(files[3].absoluteString.hasSuffix("Fixtures/dummy2.txt"))
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
