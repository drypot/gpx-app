//
//  BasicXMLParser.swift
//  GPXWorkshop
//
//  Created by drypot on 2024-04-04.
//

// 참고
// https://github.com/mmllr/GPXKit/blob/main/Sources/GPXKit/BasicXMLParser.swift

import Foundation

enum XML {
    
    enum Error: Swift.Error /*, Equatable */ {
        case parsingError(NSError, Int)
    }
    
    struct Node /*: Equatable, Hashable */ {
        var name: String = ""
        var attributes:[String: String] = [:]
        var content: String = ""
        var children: [Node] = []
    }
    
    final class Parser: NSObject, XMLParserDelegate {
        
        private var stack = [Node()]
        
        func parse(_ data: Data) -> Result<Node, Error> {
            let parser = XMLParser(data: data)
            parser.delegate = self
            let result = autoreleasepool {
                parser.parse()
            }
            if !result {
                let error = Error.parsingError(parser.parserError! as NSError, parser.lineNumber)
                return .failure(error)
            } else {
                let root = stack.first?.children.first ?? stack[0]
                return .success(root)
            }
        }
        
        func parser(_: XMLParser, didStartElement elementName: String, namespaceURI _: String?,
                    qualifiedName _: String?, attributes attributeDict: [String: String] = [:]) {
            let newNode = Node(name: elementName, attributes: attributeDict)
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

}
