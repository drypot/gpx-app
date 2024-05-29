//
//  GPX.swift
//  GPXWorkshop
//
//  Created by drypot on 2023-12-28.
//

import Foundation
import MapKit

struct GPX {
    let uuid = UUID()
    var creator: String = ""
    var version: String = ""
    var metadata: Metadata = .init()
    var waypoints: [Waypoint] = []
    //var routes: [GPXRoute]
    var tracks: [Track] = []

    struct Metadata {
        var name: String = ""
        var description: String = ""
        //var author
        //var copyright
        //var link
        //var time
        //var keywords: String?
        //var bounds:
    }

    struct Waypoint: GPXCoordinate {
        var latitude = 0.0
        var longitude = 0.0
        var elevation = 0.0
        
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

    struct Track {
        var name: String = ""
        var comment: String = ""
        var description: String = ""
        //var source: String?
        //var link
        //var number: Int?
        //var type: String?
        var segments: [Segment] = []
    }

    struct Segment {
        var points: [Point] = []
    }

    struct Point: GPXCoordinate {
        var latitude = 0.0
        var longitude = 0.0
        var elevation = 0.0
    }
}

// 참고
// https://github.com/mmllr/GPXKit/blob/main/Sources/GPXKit/Coordinate.swift

protocol GPXCoordinate {
    var latitude: Double { get set }
    var longitude: Double { get set }
    var elevation: Double { get set }
}

extension GPXCoordinate {
    func almostEqual(_ target: GPXCoordinate) -> Bool {
        (self.latitude - target.latitude).magnitude < 0.000001 &&
        (self.longitude - target.longitude).magnitude < 0.000001 &&
        (self.elevation - target.elevation).magnitude < 0.00001
    }
}
