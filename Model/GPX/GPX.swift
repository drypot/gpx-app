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

//public typealias GPXBox = NSBox<GPX>

public final class GPXBox: NSObject {

    public var value: GPX

    public init(_ value: GPX) {
        self.value = value
    }

    public override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Self else { return false }
        return self === other
    }

    public override var hash: Int {
        return ObjectIdentifier(self).hashValue
    }

    public override var description: String {
        String(describing: value)
    }
}

public struct GPX {

    //public let id = UUID()

    public var creator: String = ""
    public var version: String = ""
    public var metadata: GPXMetadata = .init()
    public var waypoints: [GPXWaypoint] = []
    //public var routes: [GPXRoute]
    public var tracks: [GPXTrack] = []
}

public struct GPXMetadata {
    public var name: String = ""
    public var description: String = ""
    //public var author
    //public var copyright
    //public var link
    //public var time
    //public var keywords: String?
    //public var bounds:
}

public struct GPXWaypoint {
    public var point: GPXPoint = GPXPoint()

    //public var time
    //public var magvar
    //public var geoidheight

    public var name: String = ""
    public var comment: String = ""
    public var description: String = ""
    //public var source
    //public var link
    public var symbol: String = ""
    public var type: String = ""

    //public var fix
    //public var satellites
    //public var hdop
    //public var vdop
    //public var pdop
    //public var ageofdgpsdata
    //public var dgpsid
}

public struct GPXTrack {
    public var name: String = ""
    public var comment: String = ""
    public var description: String = ""
    //public var source: String?
    //public var link
    //public var number: Int?
    //public var type: String?
    public var segments: [GPXSegment] = []
}

public struct GPXSegment {
    public var points: [GPXPoint] = []
}

public struct GPXPoint {
    public var latitude = 0.0
    public var longitude = 0.0
    public var elevation = 0.0

    public init(latitude: Double = 0.0, longitude: Double = 0.0, elevation: Double = 0.0) {
        self.latitude = latitude
        self.longitude = longitude
        self.elevation = elevation
    }
    
    public func almostEqual(_ target: Self) -> Bool {
        (self.latitude - target.latitude).magnitude < 0.000001 &&
        (self.longitude - target.longitude).magnitude < 0.000001 &&
        (self.elevation - target.elevation).magnitude < 0.00001
    }
}
