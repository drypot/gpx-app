//
//  BasicXMLParserTests.swift
//  DrypotGPXTests
//
//  Created by drypot on 2024-04-04.
//

import XCTest

final class BasicXMLParserTests: XCTestCase {
  
  var root = XMLNode()
  
  override func setUp() {
    do {
      let data = Data(gpxSample01Short.utf8)
      root = try BasicXMLParser().parse(data: data).get()
    } catch {
      XCTFail()
    }
  }
  
  func testRoot() throws {
    let node = root
    XCTAssertEqual(node.name, "gpx")
    XCTAssertEqual(node.attributes["creator"], "www.plotaroute.com")
    XCTAssertEqual(node.attributes["version"], "1.1")
  }
  
  func testMetadata() throws {
    let node = root.children[0]
    XCTAssertEqual(node.name, "metadata")
    XCTAssertEqual(node.children[0].name, "desc")
    XCTAssertEqual(node.children[0].content, "Route created on plotaroute.com")
  }
  
  func testTrack() throws {
    let node = root.children[1]
    XCTAssertEqual(node.name, "trk")
    XCTAssertEqual(node.children[0].name, "name")
    XCTAssertEqual(node.children[0].content, "Sample01")
  }
  
  func testTrackSegment() throws {
    let node = root.children[1].children[1]
    XCTAssertEqual(node.name, "trkseg")
    
    let point1 = root.children[1].children[1].children[0]
    XCTAssertEqual(point1.name, "trkpt")
    XCTAssertEqual(point1.attributes["lat"], "37.5323012")
    XCTAssertEqual(point1.attributes["lon"], "127.0596635")
    XCTAssertEqual(point1.children[0].name, "ele")
    XCTAssertEqual(point1.children[0].content, "15")

    let point2 = root.children[1].children[1].children[1]
    XCTAssertEqual(point2.name, "trkpt")
    XCTAssertEqual(point2.attributes["lat"], "37.5338156")
    XCTAssertEqual(point2.attributes["lon"], "127.056756")
  }
  
}
