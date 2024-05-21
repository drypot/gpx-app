//
//  MapKitSegmentDistance.swift
//  DrypotGPX
//
//  Created by Kyuhyun Park on 5/21/24.
//

import Foundation
import CoreLocation

extension MapKitSegment {
    
    // ask to ChatGPT: how to calculate distance between mapkit polyline and point
    
    func distance(from point: CLLocationCoordinate2D) -> CLLocationDistance {
        var closest = CLLocationDistance(Double.greatestFiniteMagnitude)
        guard point.latitude != 0 && point.longitude != 0 else {
            return closest
        }
        for i in 0..<(points.count - 1) {
            let distance = distance(from: point, toSegment: i)
            if distance < closest {
                closest = distance
            }
        }
        return closest
    }
    
    private func distance(from point: CLLocationCoordinate2D, toSegment segmentIndex: Int) -> CLLocationDistance {
        let p1 = points[segmentIndex]
        let p2 = points[segmentIndex + 1]
        
        let pointVector = Vector(from: p1, to: point)
        let segmentVector = Vector(from: p1, to: p2)
        
        let segmentLength = segmentVector.magnitude
        let normalizedSegmentVector = segmentVector.normalized

        let projectionLength = dotProduct(pointVector, normalizedSegmentVector)
        
        if projectionLength < 0 {
            return distanceBetween(point, p1)
        } else if projectionLength > segmentLength {
            return distanceBetween(point, p2)
        } else {
            let projection = p1.adding(vector: normalizedSegmentVector.scaled(by: projectionLength))
            return distanceBetween(point, projection)
        }
    }
}

fileprivate func dotProduct(_ a: Vector, _ b: Vector) -> Double {
    return (a.dx * b.dx) + (a.dy * b.dy)
}

// Haversine Formula
// CLLocation.distance 의 결과와는 좀 다르게 나온다. 적당히 대강만 써야.
func distanceBetween(_ p1:CLLocationCoordinate2D, _ p2:CLLocationCoordinate2D) -> CLLocationDistance {
    let toRadian = .pi / 180.0
    let lat1 = p1.latitude * toRadian
    let lon1 = p1.longitude * toRadian
    let lat2 = p2.latitude * toRadian
    let lon2 = p2.longitude * toRadian
    
    let dLat = lat2 - lat1
    let dLon = lon2 - lon1
    
    let sinDLat = sin(dLat/2)
    let sinDLon = sin(dLon/2)

    let a = sinDLat * sinDLat + sinDLon * sinDLon * cos(lat1) * cos(lat2)
    let c = 2 * asin(sqrt(a))
    let R = 6372.8

    return R * c * 1000
}

struct Vector {
    var dx: Double
    var dy: Double
    
    init(dx: Double, dy: Double) {
        self.dx = dx
        self.dy = dy
    }
    
    var magnitude: Double {
        return sqrt(dx * dx + dy * dy)
    }
    
    var normalized: Vector {
        let length = magnitude
        return Vector(dx: dx / length, dy: dy / length)
    }
    
    func scaled(by scalar: Double) -> Vector {
        return Vector(dx: dx * scalar, dy: dy * scalar)
    }
}

extension Vector {
    init(from p1: CLLocationCoordinate2D, to p2: CLLocationCoordinate2D) {
        self.init(dx: p2.longitude - p1.longitude, dy: p2.latitude - p1.latitude)
    }
}

extension CLLocationCoordinate2D {
    func adding(vector: Vector) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude + vector.dy, longitude: longitude + vector.dx)
    }
}

extension MapKitSegments {
    func closestSegment(at point: CLLocationCoordinate2D, radius: CLLocationDistance) -> MapKitSegment? {
        var closest: MapKitSegment?
        var closestDistance = Double.greatestFiniteMagnitude
        for segment in segments {
            let distance = segment.distance(from: point)
            if distance < radius, distance < closestDistance {
                closestDistance = distance
                closest = segment
            }
        }
        return closest
    }
}
