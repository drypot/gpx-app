//
//  GPXParser.swift
//  GPXWorkshop
//
//  Created by drypot on 2024-04-03.
//

// 참고
// https://github.com/mmllr/GPXKit/blob/main/Sources/GPXKit/GPXFileParser.swift

import Foundation

extension GPX {
    enum Error: Swift.Error /*, Equatable */ {
        case readingError(URL)
        case parsingError(NSError, Int)
        //case smoothingError
    }
    
    struct Parser {
        
        func parse(_ data: Data) -> Result<GPX, Error> {
            switch XML.Parser().parse(data) {
            case let .success(root):
                return parse(rootNode: root)
            case let .failure(.parsingError(error, lineNumber)):
                return .failure(.parsingError(error, lineNumber))
            }
        }
        
        private func parse(rootNode: XML.Node) -> Result<GPX, Error> {
            var gpx = GPX()
            
            gpx.creator = rootNode.attributes["creator"] ?? ""
            gpx.version = rootNode.attributes["version"] ?? ""
            
            if let metadataNode = child(of: rootNode, tag: "metadata") {
                gpx.metadata.name = content(of: metadataNode, tag: "name")
                gpx.metadata.description = content(of: metadataNode, tag: "desc")
            }
                        
            for waypointNode in children(of: rootNode, tag: "wpt") {
                let waypoint = parse(waypointNode: waypointNode)
                gpx.waypoints.append(waypoint)
            }

            for trackNode in children(of: rootNode, tag: "trk") {
                let track = parse(trackNode: trackNode)
                gpx.tracks.append(track)
            }
            
            return .success(gpx)
        }
                
        private func parse(waypointNode: XML.Node) -> Waypoint {
            var waypoint = Waypoint()
            setCoordinate(of: &waypoint, from: waypointNode)
            waypoint.name = content(of: waypointNode, tag: "name")
            waypoint.comment = content(of: waypointNode, tag: "cmt")
            waypoint.description = content(of: waypointNode, tag: "desc")
            waypoint.symbol = content(of: waypointNode, tag: "sym")
            waypoint.type = content(of: waypointNode, tag: "type")
            return waypoint
        }
        
        private func parse(trackNode: XML.Node) -> Track {
            var track = Track()
            track.name = content(of: trackNode, tag: "name")
            track.comment = content(of: trackNode, tag: "cmt")
            track.description = content(of: trackNode, tag: "desc")
            for segmentNode in children(of: trackNode, tag: "trkseg") {
                let segment = parse(segmentNode: segmentNode)
                track.segments.append(segment)
            }
            return track
        }
        
        private func parse(segmentNode: XML.Node) -> Segment {
            var segment = Segment()
            for pointNode in segmentNode.children {
                if pointNode.name != "trkpt" { continue }
                var p = Point()
                setCoordinate(of: &p, from: pointNode)
                segment.points.append(p)
            }
            return segment
        }
        
        private func child(of node: XML.Node, tag: String) -> XML.Node? {
            node.children.first {
                $0.name.lowercased() == tag
            }
        }
        
        private func children(of node: XML.Node, tag: String) -> [XML.Node] {
            node.children.filter {
                $0.name.lowercased() == tag
            }
        }
        
        private func content(of node: XML.Node, tag: String) -> String {
            child(of: node, tag: tag)?.content ?? ""
        }

        private func setCoordinate<T: GPXCoordinate>(of p: inout T, from node: XML.Node) {
            p.latitude = Double(node.attributes["lat"] ?? "") ?? 0.0
            p.longitude = Double(node.attributes["lon"] ?? "")  ?? 0.0
            p.elevation = Double(content(of: node, tag: "ele")) ?? 0.0
        }
    }
}

extension GPX {
    static func makeGPX(from url: URL) -> Result<GPX, Error> {
        guard let data = try? Data(contentsOf: url) else {
            return .failure(.readingError(url))
        }
        return Parser().parse(data)
    }
}
