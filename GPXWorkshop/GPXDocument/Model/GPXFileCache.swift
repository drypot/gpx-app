//
//  GPXFileCache.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 4/21/25.
//

import Foundation
import MapKit
import GPXWorkshopSupport

public final class GPXFileCache: NSObject {

    public private(set) var gpxFile: GPXFile
    public private(set) var polylines: [MKPolyline] = []

    public init(_ gpxFile: GPXFile) {
        self.gpxFile = gpxFile
        super.init()
        updatePolylines()
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
        String(describing: gpxFile)
    }

    // MARK: - Polyline

    public func updatePolylines() {
        polylines.removeAll()
        for track in gpxFile.tracks {
            for segment in track.segments {
                let polyline = GPXUtils.makePolyline(from: segment)
                polylines.append(polyline)
            }
        }
    }

}
