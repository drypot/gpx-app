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

public final class GPX: PointerHashable {

    //public let id = UUID()

    var creator: String = ""
    var version: String = ""
    var metadata: GPXMetadata = .init()
    var waypoints: [GPXWaypoint] = []
    //var routes: [GPXRoute]
    var tracks: [GPXTrack] = []

    public init() { }
}

public final class GPXMetadata: PointerHashable {
    var name: String = ""
    var description: String = ""
    //var author
    //var copyright
    //var link
    //var time
    //var keywords: String?
    //var bounds:

    public init() { }
}

public final class GPXWaypoint: PointerHashable {
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

    public init() { }
}

public final class GPXTrack: PointerHashable {
    var name: String = ""
    var comment: String = ""
    var description: String = ""
    //var source: String?
    //var link
    //var number: Int?
    //var type: String?
    var segments: [GPXSegment] = []

    public init() { }
}

public final class GPXSegment: PointerHashable {
    var points: [GPXPoint] = []

    public init() { }
}

public struct GPXPoint {
    var latitude = 0.0
    var longitude = 0.0
    var elevation = 0.0

    public init(latitude: Double = 0.0, longitude: Double = 0.0, elevation: Double = 0.0) {
        self.latitude = latitude
        self.longitude = longitude
        self.elevation = elevation
    }
    
    func almostEqual(_ target: Self) -> Bool {
        (self.latitude - target.latitude).magnitude < 0.000001 &&
        (self.longitude - target.longitude).magnitude < 0.000001 &&
        (self.elevation - target.elevation).magnitude < 0.00001
    }
}
