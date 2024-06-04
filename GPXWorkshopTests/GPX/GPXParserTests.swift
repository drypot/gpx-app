//
//  GPXParserTests.swift
//  GPXWorkshopTests
//
//  Created by drypot on 2024-04-07.
//

import XCTest

final class GPXParserTests: XCTestCase {
    
    static var gpx = GPX()
    
    override static func setUp() {
        let data = Data(gpxSampleManual.utf8)
        do {
            gpx = try GPXParser().parse(data)
        } catch {
            XCTFail()
        }
    }
    
    func testRoot() throws {
        let gpx = Self.gpx
        XCTAssertEqual(gpx.creator, "texteditor")
        XCTAssertEqual(gpx.version, "1.1")
    }
    
    func testMetadata() throws {
        let gpx = Self.gpx
        XCTAssertEqual(gpx.metadata.name, "name1")
        XCTAssertEqual(gpx.metadata.description, "desc1")
    }
    
    func testWaypoints() throws {
        let gpx = Self.gpx
        XCTAssertEqual(gpx.waypoints.count, 1)
        let wp = gpx.waypoints[0]
        XCTAssertEqual(wp.point.latitude, 37.5458958)
        XCTAssertEqual(wp.point.longitude, 127.0304489)
        XCTAssertEqual(wp.point.elevation, 0.0)
        XCTAssertEqual(wp.name, "wp1name")
        XCTAssertEqual(wp.comment, "wp1cmt")
        XCTAssertEqual(wp.description, "wp1desc")
        XCTAssertEqual(wp.symbol, "Flag, Blue")
        XCTAssertEqual(wp.type, "Waypoint")
    }
    
    func testTrack() throws {
        let gpx = Self.gpx
        XCTAssertEqual(gpx.tracks.count, 1)
        let t = gpx.tracks[0]
        XCTAssertEqual(t.name, "trk1name")
        XCTAssertEqual(t.comment, "trk1cmt")
        XCTAssertEqual(t.description, "trk1desc")
    }
    
    func testTrackSegment() throws {
        let gpx = Self.gpx
        XCTAssertEqual(gpx.tracks[0].segments.count, 1)
        let ps = gpx.tracks[0].segments[0].points
        XCTAssertEqual(ps[0].latitude, 37.5323012)
        XCTAssertEqual(ps[0].longitude, 127.0596635)
        XCTAssertEqual(ps[0].elevation, 15.0)
        XCTAssertEqual(ps[1].latitude, 37.5338156)
        XCTAssertEqual(ps[1].longitude, 127.056756)
        XCTAssertEqual(ps[1].elevation, 15.0)
        XCTAssertEqual(ps[2].latitude, 37.5348451)
        XCTAssertEqual(ps[2].longitude, 127.0529473)
        XCTAssertEqual(ps[2].elevation, 17.0)
    }
    
}
