//
//  XMLParserErrorTests.swift
//  GPXWorkshopTests
//
//  Created by drypot on 2024-04-07.
//

import Foundation
import Testing

struct XMLParserErrorTests {

    @Test func testNoContent() throws {
        let data = Data(gpxSampleNoContent.utf8)
        #expect(throws: XMLError.parsingError(0)) {
            try BasicXMLParser().parse(data)
        }
    }
    
    @Test func testBadFormat() throws {
        let data = Data(gpxSampleBad.utf8)
        #expect(throws: XMLError.parsingError(9)) {
            try BasicXMLParser().parse(data)
        }
    }
    
    @Test func testNoTrack() throws {
        let data = Data(gpxSampleNoTrack.utf8)
        let root = try BasicXMLParser().parse(data)
        #expect(root.name == "gpx")
        #expect(root.children.first?.name == nil)
    }
    
}
