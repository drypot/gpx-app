//
//  GPXParser.swift
//  DrypotGPX
//
//  Created by drypot on 2024-04-03.
//

import Foundation

class GPXParser: NSObject, XMLParserDelegate {
  
  let data: Data
  var gpx = GPX()
  var wayPoint = Waypoint()
  var track = Track()
  var trackSegment = TrackSegment()
  var trackPoint = TrackPoint()
  
  enum NodeType {
    case gpx
    case meatadata
    case wayPoint
    case track
    case trackPoint
  }
  
  var currentNodeType = NodeType.gpx
  var nodeTypeStack = [NodeType]()
  
  init(data: Data) {
    self.data = data
    super.init()
  }
  
  func openNode(_ newNodeType: NodeType) {
    nodeTypeStack.append(currentNodeType)
    currentNodeType = newNodeType
  }
  
  func closeNode() {
    currentNodeType = nodeTypeStack.popLast() ?? NodeType.gpx
  }
  
  func parse() {
    let parser = XMLParser(data: data)
    parser.delegate = self
    parser.parse()
  }
  
  func parserDidStartDocument(_ parser: XMLParser) {
  }
  
  func parserDidEndDocument(_ parser: XMLParser) {
  }
  
  func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?,
    attributes attributeDict: [String : String] = [:] ) {
    switch elementName {
    case "metadata":
      openNode(.meatadata)
    case "wpt":
      openNode(.wayPoint)
      if let lat = attributeDict["lat"] {
        wayPoint.latitude = Double(lat) ?? 0
      }
      if let lon = attributeDict["lon"] {
        wayPoint.longitude = Double(lon) ?? 0
      }
    //case "rte":
    case "trk":
      break
    case "name":
      break
    case "cmt":
      break
    case "desc":
      break
    case "ele":
      break
    default:
      break
    }
  }
  
  func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    switch elementName {
    case "metadata":
      closeNode()
    case "wpt":
      closeNode()
    default:
      break
    }
  }

  func parser(_ parser: XMLParser, foundCharacters string: String
  ) {
    let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
  func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error
  ) {
    //self.error = parseError
  }
  
}
