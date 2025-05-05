//
//  GPXCache.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 4/21/25.
//

import Foundation
import MapKit
import GPXWorkshopSupport

public final class GPXCache: NSObject {

    public private(set) var url: URL?
    public private(set) var filename: String?

    public private(set) var gpx: GPX
    public private(set) var polylines: [MKPolyline] = []

    public init(_ gpx: GPX) {
        self.gpx = gpx
        super.init()
        updatePolylines()
    }

    public convenience override init() {
        self.init(GPX())
    }
    
    public convenience init(_ url: URL) throws {
        let gpx = try GPXUtils.makeGPX(from: url)
        self.init(gpx)
        self.url = url
        self.filename = url.lastPathComponent
    }

    // MARK: - NSObject

    public override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Self else { return false }
        return self === other
    }

    public override var hash: Int {
        return ObjectIdentifier(self).hashValue
    }

    public override var description: String {
        String(describing: gpx)
    }

    // MARK: - Polyline

    public func updatePolylines() {
        polylines.removeAll()
        for track in gpx.tracks {
            for segment in track.segments {
                let polyline = GPXUtils.makePolyline(from: segment)
                polylines.append(polyline)
            }
        }
    }

}
