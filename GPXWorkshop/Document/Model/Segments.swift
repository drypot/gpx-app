//
//  Segments.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 5/11/24.
//

import Foundation
import MapKit

// 현재의 GPX 편집 모델은 MapKit 에 의존적이다.
// 실 표시 데이터의 대부분을 MKMapView 가 가지고 있어야 속도가 나기 때문에 어쩔 수 없다.
// MapKit 의존성을 인정하고 유기적으로 통신하는 관계로 만들어야 할 듯.
// 모델 내부 데이터 타입도 MapKit 타입을 쓰는 것이 속도에서 유리할 것 같다.
// 다른 지도 사용할 경우는, 그때 가서 생각;

extension MKPolyline {
    convenience init(_ gpxSegment: GPXSegment) {
        let points = gpxSegment.points.map {
            CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
        }
        self.init(coordinates: points, count: points.count)
    }
}

final class Segments: ObservableObject {
    
    var segments: Set<MKPolyline> = []
    
    var selectedSegments: Set<MKPolyline> = []
    
    var segmentsToAdd: [MKPolyline] = []
    var segmentsToRemove: [MKPolyline] = []
    var segmentsToUpdate: Set<MKPolyline> = []
    
    var routeSegments: [MKPolyline] = []
    
    var needZoomToFit = false
    
    init() {
    }
    
    // 모델에서 MKMapView 를 직접 받으면 안 되지만;
    // 프로토콜로 빼긴 귀찮으니 당분간은 그냥 이렇게 쓰기로 한다.
    func sync(with mapView: MapKitGPXEditViewCore) {
        if !segmentsToAdd.isEmpty {
            segmentsToAdd.forEach { polyline in
                segments.insert(polyline)
                mapView.addOverlay(polyline)
            }
            segmentsToAdd.removeAll()
        }
        if !segmentsToUpdate.isEmpty {
            segmentsToUpdate.forEach { polyline in
                mapView.removeOverlay(polyline)
                mapView.addOverlay(polyline)
            }
            segmentsToUpdate.removeAll()
        }
        if needZoomToFit {
            mapView.zoomToFitAllOverlays()
            needZoomToFit = false
        }
    }
    
    func append(_ newSegments: [MKPolyline]) {
        objectWillChange.send()
        segmentsToAdd.append(contentsOf: newSegments)
        needZoomToFit = true
    }

    func selectSegment(_ polyline: MKPolyline) {
        objectWillChange.send()
        selectedSegments.insert(polyline)
        segmentsToUpdate.insert(polyline)
    }
    
    func deselectSegment(_ polyline: MKPolyline) {
        objectWillChange.send()
        selectedSegments.remove(polyline)
        segmentsToUpdate.insert(polyline)
    }
    
    func isSelectedSegment(_ polyline: MKPolyline) -> Bool {
        return selectedSegments.contains(polyline)
    }
    
    func toggleSegmentSelection(_ polyline: MKPolyline) {
        objectWillChange.send()
        if isSelectedSegment(polyline) {
            deselectSegment(polyline)
        } else {
            selectSegment(polyline)
        }
    }
    
//    func closestSegmentV0(from point: MKMapPoint, tolerance: CLLocationDistance) -> MKPolyline? {
//        var closest: MKPolyline?
//        var minDistance: CLLocationDistance = .greatestFiniteMagnitude
//        for polyline in segments {
//            let rect = polyline.boundingMapRect.insetBy(dx: -tolerance, dy: -tolerance)
//            if !rect.contains(point) {
//                continue
//            }
//            let distance = distance(from: point, to: polyline)
//            if distance < tolerance, distance < minDistance {
//                minDistance = distance
//                closest = polyline
//            }
//        }
//        return closest
//    }

    func closestSegment(from point: MKMapPoint, tolerance: CLLocationDistance) -> MKPolyline? {
        struct Distance {
            let polyline: MKPolyline?
            let distance: CLLocationDistance
        }
        return segments.lazy
            .filter { polyline in
                polyline.boundingMapRect.insetBy(dx: -tolerance, dy: -tolerance).contains(point)
            }
            .map { polyline in
                Distance(polyline: polyline, distance: distance(from: point, to: polyline))
            }
            .reduce(Distance(polyline: nil, distance: .greatestFiniteMagnitude)) { (r, e) in
                if e.distance < tolerance, e.distance < r.distance { e } else { r }
            }
            .polyline
    }

    // Route
    
    func addRouteSegment(_ polyline: MKPolyline) {
        objectWillChange.send()
        routeSegments.append(polyline)
        self.segmentsToUpdate.insert(polyline)
    }
    
    func removeRouteSegment(_ polyline: MKPolyline) {
        objectWillChange.send()
        if let index = routeSegments.firstIndex(of: polyline) {
            routeSegments.remove(at: index)
            self.segmentsToUpdate.insert(polyline)
        }
    }

    func removeLastRouteSegment() {
        objectWillChange.send()
        if !routeSegments.isEmpty {
            let last = routeSegments.removeLast()
            self.segmentsToUpdate.insert(last)
        }
    }

    func routeContains(_ polyline: MKPolyline) -> Bool {
        return routeSegments.contains(polyline)
    }
    
    func appendOrRemoveRouteSegment(_ polyline: MKPolyline) {
        objectWillChange.send()
        if routeContains(polyline) {
            if routeSegments.last == polyline {
                removeRouteSegment(polyline)
            }
        } else {
            addRouteSegment(polyline)
        }
    }
}

func distance(from point: MKMapPoint, to polyline: MKPolyline) -> CLLocationDistance {
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

func distance(from point: MKMapPoint, toSegmentBetween pointA: MKMapPoint, and pointB: MKMapPoint) -> CLLocationDistance {
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

