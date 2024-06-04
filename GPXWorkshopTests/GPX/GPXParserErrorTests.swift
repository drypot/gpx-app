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
        var error: Error?
        XCTAssertThrowsError(try GPXParser().parse(data)) { error = $0 }
        XCTAssertEqual(error as! XMLError, XMLError.parsingError(0))
    }
    
    func testBadFormat() throws {
        let data = Data(gpxSampleBad.utf8)
        var error: Error?
        XCTAssertThrowsError(try GPXParser().parse(data)) { error = $0 }
        XCTAssertEqual(error as! XMLError, XMLError.parsingError(9))
    }
    
    func testNoTrack() throws {
        let data = Data(gpxSampleNoTrack.utf8)
        let gpx = try GPXParser().parse(data)
        XCTAssertEqual(gpx.creator, "texteditor")
        XCTAssertEqual(gpx.tracks.count, 0)
    }
    
}
