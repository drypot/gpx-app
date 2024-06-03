//
//  GPXParserErrorTests.swift
//  GPXWorkshopTests
//
//  Created by drypot on 2024-04-08.
//

import XCTest

final class GPXParserErrorTests: XCTestCase {
    
    func testNoContent() throws {
        let data = Data(gpxSampleNoContent.utf8)
        switch GPXParser().parse(data) {
        case .success:
            XCTFail()
        case .failure(.readingError(_)):
            XCTFail()
        case .failure(.parsingError(_, let lineNumber)):
            XCTAssertEqual(lineNumber, 0)
        }
    }
    
    func testBadFormat() throws {
        let data = Data(gpxSampleBad.utf8)
        switch GPXParser().parse(data) {
        case .success:
            XCTFail()
        case .failure(.readingError(_)):
            XCTFail()
        case .failure(.parsingError(_, let lineNumber)):
            XCTAssertEqual(lineNumber, 9)
        }
    }
    
    func testNoTrack() throws {
        let data = Data(gpxSampleNoTrack.utf8)
        switch GPXParser().parse(data) {
        case .success(let gpx):
            XCTAssertEqual(gpx.creator, "texteditor")
            XCTAssertEqual(gpx.tracks.count, 0)
        case .failure:
            XCTFail()
        }
    }
    
}
