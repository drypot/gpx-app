//
//  GPXExporterTests.swift
//  GPXWorkshopTests
//
//  Created by Kyuhyun Park on 8/23/24.
//

import XCTest

final class GPXExporterTests: XCTestCase {

    static var gpx: GPX?
    static var exp: GPXExporter?
    
    override static func setUp() {
        let data = Data(gpxSampleManualMultiple.utf8)
        do {
            gpx = try GPXParser().parse(data)
            exp = GPXExporter(gpx!)
        } catch {
            XCTFail()
        }
    }

    func testTrkseg() throws {
        let gpx = Self.gpx!
        let exp = Self.exp!
        let result = exp.trksegs(gpx.tracks[0].segments)
        let expected = """
            <trkseg>
            <trkpt lat="37.5323012" lon="127.0596635"><ele>0</ele></trkpt>
            <trkpt lat="37.5338156" lon="127.056756"><ele>0</ele></trkpt>
            </trkseg>
            <trkseg>
            <trkpt lat="37.5348451" lon="127.0529473"><ele>0</ele></trkpt>
            <trkpt lat="37.5365211" lon="127.0469928"><ele>0</ele></trkpt>
            <trkpt lat="37.5369805" lon="127.0454371"><ele>0</ele></trkpt>
            </trkseg>
            
            """
        XCTAssertEqual(result, expected)
    }
    
    func testTrk() throws {
        let gpx = Self.gpx!
        let exp = Self.exp!
        let result = exp.trks(gpx.tracks)
        let expected = """
            <trk>
            <trkseg>
            <trkpt lat="37.5323012" lon="127.0596635"><ele>0</ele></trkpt>
            <trkpt lat="37.5338156" lon="127.056756"><ele>0</ele></trkpt>
            </trkseg>
            <trkseg>
            <trkpt lat="37.5348451" lon="127.0529473"><ele>0</ele></trkpt>
            <trkpt lat="37.5365211" lon="127.0469928"><ele>0</ele></trkpt>
            <trkpt lat="37.5369805" lon="127.0454371"><ele>0</ele></trkpt>
            </trkseg>
            </trk>
            <trk>
            <trkseg>
            <trkpt lat="37.5323012" lon="127.0596635"><ele>0</ele></trkpt>
            <trkpt lat="37.5338156" lon="127.056756"><ele>0</ele></trkpt>
            <trkpt lat="37.5348451" lon="127.0529473"><ele>0</ele></trkpt>
            </trkseg>
            <trkseg>
            <trkpt lat="37.5365211" lon="127.0469928"><ele>0</ele></trkpt>
            <trkpt lat="37.5369805" lon="127.0454371"><ele>0</ele></trkpt>
            </trkseg>
            </trk>
            
            """
        XCTAssertEqual(result, expected)
    }
    
    func testGpx() throws {
        let exp = Self.exp!
        let result = exp.gpx(content: "<trk></trk>")
        let expected = """
            <?xml version="1.0" encoding="UTF-8"?>
            <gpx xmlns="http://www.topografix.com/GPX/1/1"
            creator="GPX Workshop" version="1.1"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd">
            <trk></trk>
            </gpx>
            """
        XCTAssertEqual(result, expected)
    }
    
}
