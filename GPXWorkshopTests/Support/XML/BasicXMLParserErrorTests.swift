//
//  XMLParserErrorTests.swift
//  GPXWorkshopTests
//
//  Created by drypot on 2024-04-07.
//

import XCTest

final class XMLParserErrorTests: XCTestCase {
    
    func testNoContent() throws {
        let data = Data(gpxSampleNoContent.utf8)
        var error: Error?
        XCTAssertThrowsError(try BasicXMLParser().parse(data)) { error = $0 }
        XCTAssertEqual(error as! XMLError, XMLError.parsingError(0))
    }
    
    func testBadFormat() throws {
        let data = Data(gpxSampleBad.utf8)
        var error: Error?
        XCTAssertThrowsError(try BasicXMLParser().parse(data)) { error = $0 }
        XCTAssertEqual(error as! XMLError, XMLError.parsingError(9))
    }
    
    func testNoTrack() throws {
        let data = Data(gpxSampleNoTrack.utf8)
        let root = try BasicXMLParser().parse(data)
        XCTAssertEqual(root.name, "gpx")
        XCTAssertEqual(root.children.first?.name, nil)
    }
    
}
