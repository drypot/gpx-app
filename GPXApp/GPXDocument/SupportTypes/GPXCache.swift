//
//  GPXCache.swift
//  GPXApp
//
//  Created by Kyuhyun Park on 4/21/25.
//

import Foundation
import MapKit
import GPXAppSupport

final class GPXCache: NSObject, Comparable {

    private(set) var url: URL?
    private(set) var filename = ""

    private(set) var gpx: GPX
    private(set) var polylines: [MKPolyline] = []

    var isSelected = false

    init(_ gpx: GPX) {
        self.gpx = gpx
        super.init()
        updatePolylines()
    }

    convenience override init() {
        self.init(GPX())
    }

    static func makeGPXCache(from url: URL) throws -> GPXCache {
        let gpx = try GPXUtils.makeGPX(from: url)
        let cache = GPXCache(gpx)
        cache.url = url
        cache.filename = url.lastPathComponent
        return cache
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
