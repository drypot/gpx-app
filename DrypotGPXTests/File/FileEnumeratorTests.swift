//
//  FileEnumeratorTests.swift
//  DrypotGPXTests
//
//  Created by Kyuhyun Park on 5/15/24.
//

import XCTest
import Combine

final class FileEnumeratorTests: XCTestCase {

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

    func testFilesSequence() throws {
        let baseURL = URL(fileURLWithPath: defaultGPXFolderPath)
        var count = 0
        
        FilesSequence(url: baseURL).prefix(5).forEach { url in
            count += 1
            //print(url)
        }
        XCTAssertEqual(count, 5)
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
    
//    func testFilesPublisherUnlimited() throws {
//        try XCTSkipIf(true, "skip unlimited FilesPublisher tests")
//        
//        let baseURL = URL(fileURLWithPath: defaultGPXFolderPath)
//        var count = 0
//        
//        let _ = FilesPublisher(url: baseURL).sink { url in
//            count += 1
//            if (count > 3000) {
//                print(count, terminator: " ")
//            }
//            XCTAssertTrue(count <= 3020)
//        }
//        XCTAssertTrue(count <= 3020)
//    }

}
