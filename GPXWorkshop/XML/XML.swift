//
//  XML.swift
//  GPXWorkshop
//
//  Created by drypot on 2024-04-04.
//

// 참고
// https://github.com/mmllr/GPXKit/blob/main/Sources/GPXKit/BasicXMLParser.swift

import Foundation

enum XMLError: Swift.Error, Equatable {
    case parsingError(Int)
}

struct XMLNode /*: Equatable, Hashable */ {
    var name: String = ""
    var attributes:[String: String] = [:]
    var content: String = ""
    var children: [XMLNode] = []
}

final class BasicXMLParser: NSObject, XMLParserDelegate {
    
    private var stack = [XMLNode()]
    
    func parse(_ data: Data) throws -> XMLNode {
        let parser = XMLParser(data: data)
        parser.delegate = self
        let result = autoreleasepool {
            parser.parse()
        }
        if !result {
            throw XMLError.parsingError(parser.lineNumber)
        }
        let root = stack.first?.children.first ?? stack[0]
        return root
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
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Swift.Error ) {
        print(parseError.localizedDescription)
    }
    
}
