//
//  GPXCache.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 4/21/25.
//

import Foundation
import MapKit
import GPXWorkshopSupport

final class GPXCache: NSObject, Comparable {

    private(set) var url: URL?
    private(set) var filename = ""

    private(set) var gpx: GPX
    private(set) var polylines: [MKPolyline] = []

    init(_ gpx: GPX) {
        self.gpx = gpx
        super.init()
        updatePolylines()
    }

    convenience override init() {
        self.init(GPX())
    }
    
    convenience init(_ url: URL) throws {
        let gpx = try GPXUtils.makeGPX(from: url)
        self.init(gpx)
        self.url = url
        self.filename = url.lastPathComponent
    }

    // MARK: - NSObject

    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Self else { return false }
        return self === other
    }

    override var hash: Int {
        return ObjectIdentifier(self).hashValue
    }

    override var description: String {
        String(describing: gpx)
    }

    // MARK: - Comparable

    static func < (lhs: GPXCache, rhs: GPXCache) -> Bool {
        return lhs.filename < rhs.filename
    }

    @objc func compare(_ object: Any?) -> ComparisonResult {
        guard let other = object as? GPXCache else { return .orderedSame }
        if self < other {
            return .orderedAscending
        } else if self > other {
            return .orderedDescending
        } else {
            return .orderedSame
        }
    }

    // MARK: - Polyline

    func updatePolylines() {
        polylines.removeAll()
        for track in gpx.tracks {
            for segment in track.segments {
                let polyline = GPXUtils.makePolyline(from: segment)
                polylines.append(polyline)
            }
        }
    }

}
