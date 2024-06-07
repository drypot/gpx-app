//
//  GPXFiles.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 6/2/24.
//

import Foundation
import MapKit

extension GPX {
    static func gpx(from data: Data) throws -> GPX {
        return try GPXParser().parse(data)
    }
    
    static func gpx(from url: URL) throws -> GPX {
        let data = try Data(contentsOf: url)
        return try gpx(from: data)
    }
}
