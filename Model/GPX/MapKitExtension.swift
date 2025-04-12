//
//  MapKitExtension.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 8/20/24.
//

import Foundation
import MapKit

// 현재의 GPX 편집 모델은 MapKit 에 의존적이다.
// 실 표시 데이터의 대부분을 MKMapView 가 가지고 있어야 속도가 나기 때문에 어쩔 수 없다.
// MapKit 의존성을 인정하고 유기적으로 통신하는 관계로 만들어야 할 듯.
// 모델 내부 데이터 타입도 MapKit 타입을 쓰는 것이 속도에서 유리할 것 같다.
// 다른 지도 사용할 경우는, 그때 가서 생각;

extension GPX {
    func addTracks(from polylines: Set<MKPolyline>) {
        for polyline in polylines {
            let track = GPXTrack()
            let segment = GPXSegment(polyline)
            track.segments.append(segment)
            self.tracks.append(track)
        }
    }
}

extension GPXSegment {
    convenience init(_ polyline: MKPolyline) {
        self.init()
        let count = polyline.pointCount
        let pointer = polyline.points()
        for i in 0 ..< count {
            let c = pointer[i].coordinate
            let point = GPXPoint(latitude: c.latitude, longitude: c.longitude, elevation: 0)
            points.append(point)
        }
    }
}

public struct PolylineFactory {

    public init() {
    }
    
    public func makePolyline(from gpxSegment: GPXSegment) -> MKPolyline {
        let points = gpxSegment.points.map {
            CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
        }
        return MKPolyline(coordinates: points, count: points.count)
    }

    public func makePolylines(from gpxData: Data) throws -> [MKPolyline] {
        var polylines: [MKPolyline] = []
        let gpx = try GPX.gpx(from: gpxData)
        for track in gpx.tracks {
            for segment in track.segments {
                polylines.append(self.makePolyline(from: segment))
            }
        }
        return polylines
    }

    public func makePolylines(from urls: [URL]) async throws -> [MKPolyline] {
        var polylines: [MKPolyline] = []
        for url in Files(urls: urls) {
            let gpx = try GPX.gpx(from: url)
            for track in gpx.tracks {
                for segment in track.segments {
                    polylines.append(self.makePolyline(from: segment))
                }
            }
        }
        return polylines
    }
}

public func distance(from point: MKMapPoint, to polyline: MKPolyline) -> CLLocationDistance {
    var minDistance: CLLocationDistance = .greatestFiniteMagnitude

    let points = polyline.points()
    let pointCount = polyline.pointCount
    
    for i in 0 ..< pointCount - 1 {
        let pointA = points[i]
        let pointB = points[i + 1]
        let distance = distance(from: point, toSegmentBetween: pointA, and: pointB)
        minDistance = min(minDistance, distance)
    }
    
    return minDistance
}

public func distance(from point: MKMapPoint, toSegmentBetween pointA: MKMapPoint, and pointB: MKMapPoint) -> CLLocationDistance {
    let x0 = point.x
    let y0 = point.y
    let x1 = pointA.x
    let y1 = pointA.y
    let x2 = pointB.x
    let y2 = pointB.y
    
    let dx = x2 - x1
    let dy = y2 - y1
    
    if dx == 0 && dy == 0 {
        // Points A and B are the same
        return pointA.distance(to: point)
    }
    
    // Project point onto the line segment
    let t = ((x0 - x1) * dx + (y0 - y1) * dy) / (dx * dx + dy * dy)
    
    if t < 0 {
        // Closest to point A
        return pointA.distance(to: point)
    } else if t > 1 {
        // Closest to point B
        return pointB.distance(to: point)
    } else {
        // Closest to the line segment
        let projection = MKMapPoint(x: x1 + t * dx, y: y1 + t * dy)
        return projection.distance(to: point)
    }
}
