//
//  BasicXMLParserTests.swift
//  GPXWorkshopTests
//
//  Created by drypot on 2024-04-04.
//

import Foundation
import Testing

struct BasicXMLParserTests {

    static var root: XMLNode = {
        let data = Data(gpxSamplePlotaRouteShort.utf8)
        do {
            return try BasicXMLParser().parse(data)
        } catch {
            fatalError()
        }
    }()

    @Test func testRoot() throws {
        let node = Self.root
        #expect(node.name == "gpx")
        #expect(node.attributes["creator"] == "www.plotaroute.com")
        #expect(node.attributes["version"] == "1.1")
    }
    
    @Test func testMetadata() throws {
        let node = Self.root.children[0]
        #expect(node.name == "metadata")
        #expect(node.children[0].name == "desc")
        #expect(node.children[0].content == "Route created on plotaroute.com")
    }
    
    @Test func testTrack() throws {
        let node = Self.root.children[1]
        #expect(node.name == "trk")
        #expect(node.children[0].name == "name")
        #expect(node.children[0].content == "Sample01")
    }
    
    @Test func testTrackSegment() throws {
        let node = Self.root.children[1].children[1]
        #expect(node.name == "trkseg")

        let point1 = Self.root.children[1].children[1].children[0]
        #expect(point1.name == "trkpt")
        #expect(point1.attributes["lat"] == "37.5323012")
        #expect(point1.attributes["lon"] == "127.0596635")
        #expect(point1.children[0].name == "ele")
        #expect(point1.children[0].content == "15")

        let point2 = Self.root.children[1].children[1].children[1]
        #expect(point2.name == "trkpt")
        #expect(point2.attributes["lat"] == "37.5338156")
        #expect(point2.attributes["lon"] == "127.056756")
    }
    
}
