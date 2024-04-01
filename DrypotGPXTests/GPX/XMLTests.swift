//
//  XMLTests.swift
//  DrypotGPXTests
//
//  Created by drypot on 2024-04-02.
//

import XCTest

final class XMLTests: XCTestCase {
  
  let gpxSample = """
  <?xml version="1.0" encoding="UTF-8" standalone="no"?>
  <gpx xmlns="http://www.topografix.com/GPX/1/1" creator="www.plotaroute.com" version="1.1"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd">
    <metadata>
      <desc>Route created on plotaroute.com</desc>
    </metadata>
    <trk>
      <name>Sample01</name>
      <trkseg>
        <trkpt lat="37.5323012" lon="127.0596635">
          <ele>15</ele>
          <time>2024-04-01T00:00:00Z</time>
        </trkpt>
        <trkpt lat="37.5338156" lon="127.056756">
          <ele>15</ele>
          <time>2024-04-01T00:04:51Z</time>
        </trkpt>
      </trkseg>
    </trk>
  </gpx>
  """
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testXMLParserDidStartDocument() throws {
    let data = Data(gpxSample.utf8)
    let parser = XMLParser(data: data)
    
    class Delegate: NSObject, XMLParserDelegate {
      
      func parserDidStartDocument(_ parser: XMLParser) {
        XCTAssertEqual(1, parser.lineNumber)
      }
      
      func parserDidEndDocument(_ parser: XMLParser) {
        XCTAssertEqual(21, parser.lineNumber)
      }
    }
    
    let delegate = Delegate()
    parser.delegate = delegate
    parser.parse()
  }
  
  func testXMLParserHandlingElement() throws {
    let data = Data(gpxSample.utf8)
    let parser = XMLParser(data: data)
    
    class Delegate: NSObject, XMLParserDelegate {
      var nameCount = 0
      var trkptCount = 0
      var allCount = 0
      
      func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]
      ) {
        switch elementName {
        case "name" : nameCount += 1
        case "trkpt" : trkptCount += 1
        default: break
        }
        allCount += 1
      }
    }
    
    let delegate = Delegate()
    parser.delegate = delegate
    parser.parse()
    
    XCTAssertEqual(delegate.nameCount, 1)
    XCTAssertEqual(delegate.trkptCount, 2)
    XCTAssertEqual(delegate.allCount, 12)
  }
  
  func testXMLParserHandlingAttributes() throws {
    let data = Data(gpxSample.utf8)
    let parser = XMLParser(data: data)
    
    class Delegate: NSObject, XMLParserDelegate {
      
      let lats = ["37.5323012", "37.5338156"]
      
      func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]
      ) {
        if elementName == "trkpt" {
          XCTAssertTrue(lats.contains(attributeDict["lat"]!))
        }
      }
    }
    
    let delegate = Delegate()
    parser.delegate = delegate
    parser.parse()
  }
  
  func testXMLParserHandlingText() throws {
    let data = Data(gpxSample.utf8)
    let parser = XMLParser(data: data)
    
    let answer = [
      "Route created on plotaroute.com",
      "Sample01",
      "15",
      "2024-04-01T00:00:00Z",
      "15",
      "2024-04-01T00:04:51Z"
    ]
    
    class Delegate: NSObject, XMLParserDelegate {
      var result = [String]()
      func parser(
        _ parser: XMLParser,
        foundCharacters string: String
      ) {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed != "" {
          result.append(trimmed)
        }
      }
    }
    
    let delegate = Delegate()
    parser.delegate = delegate
    parser.parse()
    
    XCTAssertTrue(answer.elementsEqual(delegate.result))
  }
  
  func testXMLParserHandlingError() throws {
    let badSample = """
      <trk>
        <name>Sample01</name>
        <trkseg>
          <trkpt lat="37.5323012" lon="127.0596635">
            <ele>15</ele>
            <time>2024-04-01T00:00:00Z</time>
          <!--</trkpt>-->
        </trkseg>
      </trk>
    """

    let data = Data(badSample.utf8)
    let parser = XMLParser(data: data)
    
    
    class Delegate: NSObject, XMLParserDelegate {
      var error: Error?
      func parser(
        _ parser: XMLParser,
        parseErrorOccurred parseError: Error
      ) {
        self.error = parseError
      }
    }
    
    let delegate = Delegate()
    parser.delegate = delegate
    parser.parse()
    
    XCTAssertNotNil(delegate.error)
  }
}
