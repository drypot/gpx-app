//
//  BasicXMLParser.swift
//  DrypotGPX
//
//  Created by drypot on 2024-04-04.
//

// 참고
// https://github.com/mmllr/GPXKit/blob/main/Sources/GPXKit/BasicXMLParser.swift

import Foundation

enum XMLParsingError: Error /*, Equatable */ {
  case noContent
  case parsingError(NSError, Int)
}

struct XMLNode /*: Equatable, Hashable */ {
  var name: String = ""
  var attributes = [String: String]()
  var content = ""
  var children = [XMLNode]()
}

class BasicXMLParser: NSObject, XMLParserDelegate {
  private var stack = [XMLNode(name: "")]
  
  public func parse(data: Data) -> Result<XMLNode, XMLParsingError> {
    let parser = XMLParser(data: data)
    parser.delegate = self
    let parseResult = autoreleasepool {
      parser.parse()
    }
    if parseResult {
      guard let root = stack.first?.children.first else {
        return .failure(.noContent)
      }
      return .success(root)
    } else {
      let error = XMLParsingError.parsingError(parser.parserError! as NSError, parser.lineNumber)
      return .failure(error)
    }
  }
  
  func parser(_: XMLParser, didStartElement elementName: String, namespaceURI _: String?,
                     qualifiedName _: String?, attributes attributeDict: [String: String] = [:]) {
    let newNode = XMLNode(name: elementName, attributes: attributeDict)
    stack.append(newNode)
  }
  
  func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?,
              qualifiedName qName: String?) {
    stack[stack.count - 2].children.append(stack.last!)
    stack.removeLast()
  }
  
  func parser(_ parser: XMLParser, foundCharacters string: String ) {
    stack[stack.count - 1].content += string.trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
  func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error ) {
    print(parseError.localizedDescription)
  }
}
