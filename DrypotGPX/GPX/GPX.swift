//
//  GPX.swift
//  DrypotGPX
//
//  Created by drypot on 2023-12-28.
//

import Foundation

class GPX {
  // var creator = ""
  // var version = ""
  let metadata = GPXMetadata()
  let waypoints = [Waypoint]()
  let tracks = [Track]()
}

struct GPXMetadata {
  var name: String?
  var desc: String?
}

struct Waypoint: Coordinate {
  var latitude: Double = 0
  var longitude: Double = 0
  var elevation: Double = 0

  //var time: Date?
  var name: String?
  var comment: String?
  var description: String?
}

struct Track {
  var name: String?
  //var comment: String?
  //var description: String?
  //var number: Int?
  var trackSegments = [TrackSegment]()
}

struct TrackSegment {
  var trackPoints = [TrackPoint]()
}

struct TrackPoint: Coordinate {
  var latitude: Double = 0
  var longitude: Double = 0
  var elevation: Double = 0
}

// 참고
// https://github.com/mmllr/GPXKit/blob/main/Sources/GPXKit/Coordinate.swift

protocol Coordinate {
  var latitude: Double { get }
  var longitude: Double { get }
  var elevation: Double { get }
}

extension Coordinate {
  func almostEqual(_ target: Coordinate) -> Bool {
    (self.latitude - target.latitude).magnitude < 0.000001 &&
    (self.longitude - target.longitude).magnitude < 0.000001 &&
    (self.elevation - target.elevation).magnitude < 0.00001
  }
}
