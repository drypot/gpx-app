//
//  GPXParser.swift
//  DrypotGPX
//
//  Created by drypot on 2024-04-03.
//

// 참고
// https://github.com/mmllr/GPXKit/blob/main/Sources/GPXKit/GPXFileParser.swift

import Foundation

enum GPXParsingError: Error /*, Equatable */ {
    case parsingError(NSError, Int)
    //case smoothingError
}

enum GPXTags: String {
    case gpx
    
    case metadata
    case waypoint = "wpt"
    case route = "rte"
    case routePoint = "rtept"
    case track = "trk"
    case trackPoint = "trkpt"
    case trackSegment = "trkseg"
    
    case name
    case comment = "cmt"
    case description = "desc"
    case author
    case copyright
    case link
    case time
    case keywords
    case bounds
    
    case elevation = "ele"
    
    case source = "src"
    case symbol = "sym"
    case type
    
    case extensions
}

enum GPXAttributes: String {
    case creator
    case version
    case latitude = "lat"
    case longitude = "lon"
}

class GPXParser {
    
    func parse(data: Data) -> Result<GPX, GPXParsingError> {
        switch BasicXMLParser().parse(data: data) {
        case let .success(root):
            return parseRoot(root: root)
        case let .failure(.parsingError(error, lineNumber)):
            return .failure(.parsingError(error, lineNumber))
        }
    }
    
    private func parseRoot(root: XMLNode) -> Result<GPX, GPXParsingError> {
        let gpx = GPX()
        gpx.creator = root.attributes[GPXAttributes.creator.rawValue] ?? ""
        gpx.version = root.attributes[GPXAttributes.version.rawValue] ?? ""
        parseMetadata(root: root, gpx: gpx)
        parseWaypoints(root: root, gpx: gpx)
        parseTracks(root: root, gpx: gpx)
        return .success(gpx)
    }
    
    private func parseMetadata(root: XMLNode, gpx: GPX) {
        guard let node = child(of: root, tag: .metadata) else { return }
        let md = gpx.metadata
        md.name = content(of: node, tag: .name)
        md.description = content(of: node, tag: .description)
    }
    
    private func parseWaypoints(root: XMLNode, gpx: GPX) {
        let nodes = children(of: root, tag: .waypoint)
        for node in nodes {
            var p = GPXWaypoint()
            setCoordinate(&p, from: node)
            p.name = content(of: node, tag: .name)
            p.comment = content(of: node, tag: .comment)
            p.description = content(of: node, tag: .description)
            p.symbol = content(of: node, tag: .symbol)
            p.type = content(of: node, tag: .type)
            gpx.waypoints.append(p)
        }
    }
    
    private func parseTracks(root: XMLNode, gpx: GPX) {
        let nodes = children(of: root, tag: .track)
        for node in nodes {
            let t = GPXTrack()
            t.name = content(of: node, tag: .name)
            t.comment = content(of: node, tag: .comment)
            t.description = content(of: node, tag: .description)
            parseSegments(trackNode: node, track: t)
            gpx.tracks.append(t)
        }
    }
    
    private func parseSegments(trackNode: XMLNode, track: GPXTrack) {
        let nodes = children(of: trackNode, tag: .trackSegment)
        for node in nodes {
            let s = GPXSegment()
            parsePoints(trackSegmentNode: node, trackSegment: s)
            track.segments.append(s)
        }
    }
    
    private func parsePoints(trackSegmentNode: XMLNode, trackSegment: GPXSegment) {
        for node in trackSegmentNode.children {
            if node.name != "trkpt" { continue }
            var p = GPXPoint()
            setCoordinate(&p, from: node)
            trackSegment.points.append(p)
        }
    }
    
    private func setCoordinate<T: GPXCoordinate>(_ p: inout T, from node: XMLNode) {
        p.latitude = Double(node.attributes[GPXAttributes.latitude.rawValue] ?? "") ?? 0.0
        p.longitude = Double(node.attributes[GPXAttributes.longitude.rawValue] ?? "")  ?? 0.0
        p.elevation = Double(content(of: node, tag: .elevation)) ?? 0.0
    }
    
    private func child(of node: XMLNode, tag: GPXTags) -> XMLNode? {
        node.children.first {
            $0.name.lowercased() == tag.rawValue
        }
    }
    
    private func children(of node: XMLNode, tag: GPXTags) -> [XMLNode] {
        node.children.filter {
            $0.name.lowercased() == tag.rawValue
        }
    }
    
    private func content(of node: XMLNode, tag: GPXTags) -> String {
        child(of: node, tag: tag)?.content ?? ""
    }
    
}
