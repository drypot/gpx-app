//
//  GPXParserErrorTests.swift
//  ModelTests
//
//  Created by drypot on 2024-04-08.
//

import Foundation
import Testing
@testable import GPXWorkshopSupport

struct GPXParserErrorTests {

    typealias XMLError = BasicXMLParser.XMLError

    @Test func testNoContent() throws {
        let data = Data(gpxSampleNoContent.utf8)
        #expect(throws: XMLError.parsingError(0)) {
            try GPXParser().parse(data)
        }
    }
    
    @Test func testBadFormat() throws {
        let data = Data(gpxSampleBad.utf8)
        #expect(throws: XMLError.parsingError(9)) {
            try GPXParser().parse(data)
        }
    }
    
    @Test func testNoTrack() throws {
        let data = Data(gpxSampleNoTrack.utf8)
        let gpx = try GPXParser().parse(data)
        #expect(gpx.creator == "texteditor")
        #expect(gpx.tracks.count == 0)
    }
    
}
