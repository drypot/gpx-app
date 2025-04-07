//
//  GPXParserTests.swift
//  GPXWorkshopTests
//
//  Created by drypot on 2024-04-07.
//

import Foundation
import Testing

struct GPXParserTests {

    static var gpx = {
        let data = Data(gpxSampleManual.utf8)
        do {
            return try GPXParser().parse(data)
        } catch {
            fatalError()
        }
    }()

    @Test func testRoot() throws {
        let gpx = Self.gpx
        #expect(gpx.creator == "texteditor")
        #expect(gpx.version == "1.1")
    }
    
    @Test func testMetadata() throws {
        let gpx = Self.gpx
        #expect(gpx.metadata.name == "name1")
        #expect(gpx.metadata.description == "desc1")
    }
    
    @Test func testWaypoints() throws {
        let gpx = Self.gpx
        #expect(gpx.waypoints.count == 1)

        let wp = gpx.waypoints[0]
        #expect(wp.point.latitude == 37.5458958)
        #expect(wp.point.longitude == 127.0304489)
        #expect(wp.point.elevation == 0.0)
        #expect(wp.name == "wp1name")
        #expect(wp.comment == "wp1cmt")
        #expect(wp.description == "wp1desc")
        #expect(wp.symbol == "Flag, Blue")
        #expect(wp.type == "Waypoint")
    }
    
    @Test func testTrack() throws {
        let gpx = Self.gpx
        #expect(gpx.tracks.count == 1)

        let t = gpx.tracks[0]
        #expect(t.name == "trk1name")
        #expect(t.comment == "trk1cmt")
        #expect(t.description == "trk1desc")
    }
    
    @Test func testTrackSegment() throws {
        let gpx = Self.gpx
        #expect(gpx.tracks[0].segments.count == 1)

        let ps = gpx.tracks[0].segments[0].points
        #expect(ps[0].latitude == 37.5323012)
        #expect(ps[0].longitude == 127.0596635)
        #expect(ps[0].elevation == 15.0)
        #expect(ps[1].latitude == 37.5338156)
        #expect(ps[1].longitude == 127.056756)
        #expect(ps[1].elevation == 15.0)
        #expect(ps[2].latitude == 37.5348451)
        #expect(ps[2].longitude == 127.0529473)
        #expect(ps[2].elevation == 17.0)
    }
    
}
