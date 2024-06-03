//
//  GPXFiles.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 6/2/24.
//

import Foundation
import MapKit

extension GPX {
    static func makeGPX(from url: URL) -> Result<GPX, GPXError> {
        guard let data = try? Data(contentsOf: url) else {
            return .failure(.readingError(url))
        }
        return GPXParser().parse(data)
    }
    
    static func makeGPX(from data: Data) -> Result<GPX, GPXError> {
        return GPXParser().parse(data)
    }
}
