//
//  GPX.swift
//  GPXWorkshop
//
//  Created by drypot on 2023-12-28.
//

import Foundation
import MapKit

// 참고
// https://github.com/mmllr/GPXKit/blob/main/Sources/GPXKit/Coordinate.swift

struct GPX {
    let uuid = UUID()
    var creator: String = ""
    var version: String = ""
    var metadata: GPXMetadata = .init()
    var waypoints: [GPXWaypoint] = []
    //var routes: [GPXRoute]
    var tracks: [GPXTrack] = []
}

struct GPXMetadata {
    var name: String = ""
    var description: String = ""
    //var author
    //var copyright
    //var link
    //var time
    //var keywords: String?
    //var bounds:
}

struct GPXWaypoint {
    var point: GPXPoint = GPXPoint()
    
    //var time
    //var magvar
    //var geoidheight
    
    var name: String = ""
    var comment: String = ""
    var description: String = ""
    //var source
    //var link
    var symbol: String = ""
    var type: String = ""
    
    //var fix
    //var satellites
    //var hdop
    //var vdop
    //var pdop
    //var ageofdgpsdata
    //var dgpsid
}

struct GPXTrack {
    var name: String = ""
    var comment: String = ""
    var description: String = ""
    //var source: String?
    //var link
    //var number: Int?
    //var type: String?
    var segments: [GPXSegment] = []
}

struct GPXSegment {
    var points: [GPXPoint] = []
}

struct GPXPoint {
    var latitude = 0.0
    var longitude = 0.0
    var elevation = 0.0

    func almostEqual(_ target: Self) -> Bool {
        (self.latitude - target.latitude).magnitude < 0.000001 &&
        (self.longitude - target.longitude).magnitude < 0.000001 &&
        (self.elevation - target.elevation).magnitude < 0.00001
    }
}
