//
//  XMLParserTests.swift
//  GPXWorkshopTests
//
//  Created by drypot on 2024-04-02.
//

import Foundation
import Testing

struct XMLParserTests {

    @Test func testXMLParserDidStartDocument() throws {
        let data = Data(gpxSamplePlotaRouteShort.utf8)
        let parser = XMLParser(data: data)
        
        class Delegate: NSObject, XMLParserDelegate {
            let logger = SimpleLogger<String>()

            func parserDidStartDocument(_ parser: XMLParser) {
                logger.append("start: \(parser.lineNumber)")
            }
            
            func parserDidEndDocument(_ parser: XMLParser) {
                logger.append("end: \(parser.lineNumber)")
            }
        }
        
        let delegate = Delegate()
        parser.delegate = delegate
        parser.parse()

        #expect(delegate.logger.result() == [
            "start: 1",
            "end: 21"
        ])
    }
    
    @Test func testXMLParserHandlingElement() throws {
        let data = Data(gpxSamplePlotaRouteShort.utf8)
        let parser = XMLParser(data: data)
        
        class Delegate: NSObject, XMLParserDelegate {
            let logger = SimpleLogger<String>()

            func parser(
                _ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]
            ) {
                logger.append(elementName)
            }
        }
        
        let delegate = Delegate()
        parser.delegate = delegate
        parser.parse()
        
        #expect(delegate.logger.result() == [
            "gpx", "metadata", "desc", "trk", "name", "trkseg", "trkpt", "ele", "time", "trkpt", "ele", "time"
        ])
    }
    
    @Test func testXMLParserHandlingAttributes() throws {
        let data = Data(gpxSamplePlotaRouteShort.utf8)
        let parser = XMLParser(data: data)
        
        class Delegate: NSObject, XMLParserDelegate {
            let logger = SimpleLogger<String>()

            func parser(
                _ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]
            ) {
                if elementName == "trkpt" {
                    logger.append("\(attributeDict["lat"]!)")
                }
            }
        }
        
        let delegate = Delegate()
        parser.delegate = delegate
        parser.parse()

        #expect(delegate.logger.result() == [
            "37.5323012",
            "37.5338156"
        ])
    }
    
    @Test func testXMLParserHandlingText() throws {
        let data = Data(gpxSamplePlotaRouteShort.utf8)
        let parser = XMLParser(data: data)
        
        class Delegate: NSObject, XMLParserDelegate {
            let logger = SimpleLogger<String>()

            func parser(
                _ parser: XMLParser,
                foundCharacters string: String
            ) {
                let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
                if trimmed != "" {
                    logger.append(trimmed)
                }
            }
        }
        
        let delegate = Delegate()
        parser.delegate = delegate
        parser.parse()
        
        #expect(delegate.logger.result() == [
            "Route created on plotaroute.com",
            "Sample01",
            "15",
            "2024-04-01T00:00:00Z",
            "15",
            "2024-04-01T00:04:51Z"
        ])
    }
    
    @Test func testXMLParserHandlingError() throws {
        let data = Data(gpxSampleBad.utf8)
        let parser = XMLParser(data: data)
        
        class Delegate: NSObject, XMLParserDelegate {
            let logger = SimpleLogger<String>()

            func parser(
                _ parser: XMLParser,
                parseErrorOccurred parseError: Error
            ) {
                logger.append("error: \(parser.lineNumber)")
            }
        }
        
        let delegate = Delegate()
        parser.delegate = delegate
        parser.parse()
        
        #expect(delegate.logger.result() == [
            "error: 8"
        ])
    }
}
