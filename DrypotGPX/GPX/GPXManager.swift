//
//  GPXManager.swift
//  DrypotGPX
//
//  Created by Kyuhyun Park on 5/14/24.
//

import Foundation

class GPXManager {

    static let shared = GPXManager()
    
    private init() {
    }

    func gpxFromSampleString(string: String = gpxSampleManual) -> GPX {
        let data = Data(string.utf8)
        switch GPXParser().parse(data: data) {
        case let .success(gpx):
            return gpx
        case .failure(_):
            fatalError()
        }
    }

}
