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
    
    private func distance(from point: CLLocationCoordinate2D, toSegment i: Int) -> CLLocationDistance {
        let a = points[i]
        let b = points[i + 1]
        
        let pointVector = vector(from: a, to: point)
        let segmentVector = vector(from: a, to: b)
        
        let segmentLength = segmentVector.magnitude
        let normalizedSegmentVector = segmentVector.normalized
        
        let projectionLength = dotProduct(pointVector, normalizedSegmentVector)
        
        if projectionLength < 0 {
            return point.distance(from: a)
        } else if projectionLength > segmentLength {
            return point.distance(from: b)
        } else {
            let projection = a.adding(vector: normalizedSegmentVector.scaled(by: projectionLength))
            return point.distance(from: projection)
        }
    }
    
    private func vector(from a: CLLocationCoordinate2D, to b: CLLocationCoordinate2D) -> Vector {
        return Vector(dx: b.longitude - a.longitude, dy: b.latitude - a.latitude)
    }
    
    private func dotProduct(_ a: Vector, _ b: Vector) -> Double {
        return (a.dx * b.dx) + (a.dy * b.dy)
    }
}

extension CLLocationCoordinate2D {
    // Haversine Formula
    // CLLocation.distance 의 결과와는 좀 다르게 나온다. 적당히 대강만 써야.
    func distance(from b:CLLocationCoordinate2D) -> CLLocationDistance {
        let earthRadiusKm: Double = 6371
        
        let dLat = (b.latitude - self.latitude).radiansFromDegrees
        let dLon = (b.longitude - self.longitude).radiansFromDegrees
        
        let ar = self.latitude.radiansFromDegrees
        let br = b.latitude.radiansFromDegrees
        
        let c = sin(dLat/2) * sin(dLat/2) + sin(dLon/2) * sin(dLon/2) * cos(ar) * cos(br)
        let d = 2 * atan2(sqrt(c), sqrt(1 - c))
        return earthRadiusKm * d * 1000
    }
}

extension Double {
    var radiansFromDegrees: Double {
        return self * .pi / 180.0
    }
}

extension CLLocationCoordinate2D {
    func adding(vector: Vector) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude + vector.dy, longitude: longitude + vector.dx)
    }
}

struct Vector {
    var dx: Double
    var dy: Double
    
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
