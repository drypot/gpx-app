//
//  GPX.swift
//  DrypotGPX
//
//  Created by drypot on 2023-12-28.
//

import Foundation

struct GPX {
  let waypoints: [Waypoint]
  let track: Track
}

struct Track {
  let name: String
  var trackPoints: [TrackPoint]
}

struct TrackPoint {
  var coordinate: Coordinate
  //let time: Date
}

struct Waypoint {
  var coordinate: Coordinate
  //let date: Date?
  var name: String?
  var comment: String?
  var description: String?
  // var type: String?
  
  init(coordinate: Coordinate, name: String? = nil, comment: String? = nil, description: String? = nil) {
    self.coordinate = coordinate
    self.name = name
    self.comment = comment
    self.description = description
  }
}
