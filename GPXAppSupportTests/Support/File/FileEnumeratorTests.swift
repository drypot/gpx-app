//
//  FileEnumeratorTests.swift
//  ModelTests
//
//  Created by Kyuhyun Park on 5/15/24.
//

import Foundation
import Testing
@testable import GPXAppSupport

struct FileEnumeratorTests {

    func fixtureURL(_ fixture: String) -> URL {
        return URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .appendingPathComponent("Fixtures")
            .appendingPathComponent(fixture)
    }

    @Test func testAll() throws {
        let url = fixtureURL("")

        let files = Files(url: url)
            .map { $0.absoluteString }
            .compactMap {
                guard let range = $0.range(of: "Fixtures") else { return nil }
                return String($0[range.upperBound...])
            }
            .sorted(by: <)

        #expect(files == [
            "/Sub1/Sub2/dummy5.txt",
            "/Sub1/Sub2/dummy6.txt",
            "/Sub1/Sub3/dummy7.txt",
            "/Sub1/Sub3/dummy8.txt",
            "/Sub1/dummy3.txt",
            "/Sub1/dummy4.txt",
            "/dummy1.txt",
            "/dummy2.txt"
        ])
    }

    @Test func testSub1() throws {
        let url = fixtureURL("Sub1")

        let files = Files(url: url)
            .map { $0.absoluteString }
            .compactMap {
                guard let range = $0.range(of: "Fixtures") else { return nil }
                return String($0[range.upperBound...])
            }
            .sorted(by: <)

        #expect(files == [
            "/Sub1/Sub2/dummy5.txt",
            "/Sub1/Sub2/dummy6.txt",
            "/Sub1/Sub3/dummy7.txt",
            "/Sub1/Sub3/dummy8.txt",
            "/Sub1/dummy3.txt",
            "/Sub1/dummy4.txt",
        ])
    }

    @Test func testSub1Dummy1() throws {
        let urls = [
            fixtureURL("dummy1.txt"),
            fixtureURL("Sub1")
        ]

        let files = Files(urls: urls)
            .map { $0.absoluteString }
            .compactMap {
                guard let range = $0.range(of: "Fixtures") else { return nil }
                return String($0[range.upperBound...])
            }
            .sorted(by: <)

        #expect(files == [
            "/Sub1/Sub2/dummy5.txt",
            "/Sub1/Sub2/dummy6.txt",
            "/Sub1/Sub3/dummy7.txt",
            "/Sub1/Sub3/dummy8.txt",
            "/Sub1/dummy3.txt",
            "/Sub1/dummy4.txt",
            "/dummy1.txt",
        ])
    }

    @Test func testEnumerateFiles() throws {
        let url = fixtureURL("")
        var resultURLs = [URL]()

        let result = enumerateFiles(url: url) { url in
            resultURLs.append(url)
            return .success(true)
        }

        let files = resultURLs
            .map { $0.absoluteString }
            .compactMap {
                guard let range = $0.range(of: "Fixtures") else { return nil }
                return String($0[range.upperBound...])
            }
            .sorted(by: <)
        
        switch result {
        case .success:
            #expect(files == [
                "/Sub1/Sub2/dummy5.txt",
                "/Sub1/Sub2/dummy6.txt",
                "/Sub1/Sub3/dummy7.txt",
                "/Sub1/Sub3/dummy8.txt",
                "/Sub1/dummy3.txt",
                "/Sub1/dummy4.txt",
                "/dummy1.txt",
                "/dummy2.txt"
            ])
        case .failure:
            fatalError()
        }
    }

    @Test func testFilesPublisher() throws {
        let url = fixtureURL("")
        var resultURLs = [URL]()

        let _ = FilesPublisher(url: url).sink { url in
            resultURLs.append(url)
        }

        let files = resultURLs
            .map { $0.absoluteString }
            .compactMap {
                guard let range = $0.range(of: "Fixtures") else { return nil }
                return String($0[range.upperBound...])
            }
            .sorted(by: <)

        #expect(files == [
            "/Sub1/Sub2/dummy5.txt",
            "/Sub1/Sub2/dummy6.txt",
            "/Sub1/Sub3/dummy7.txt",
            "/Sub1/Sub3/dummy8.txt",
            "/Sub1/dummy3.txt",
            "/Sub1/dummy4.txt",
            "/dummy1.txt",
            "/dummy2.txt"
        ])
    }

}
