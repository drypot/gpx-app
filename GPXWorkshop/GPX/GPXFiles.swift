//
//  GPXFiles.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 6/2/24.
//

import Foundation
import MapKit

extension GPX {
    static func makeGPX(from url: URL) throws -> GPX {
        let data = try Data(contentsOf: url)
        return try GPXParser().parse(data)
    }
    
    static func makeGPX(from data: Data) throws -> GPX {
        return try GPXParser().parse(data)
    }
}
