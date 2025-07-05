//
//  Globals.swift
//  GPXApp
//
//  Created by Kyuhyun Park on 5/16/24.
//

import Foundation

let sampleGPXFolderPath = "Documents/GPX Files Subset"

var isRunningTests: Bool = {
    return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
}()

class GlobalActions {
    typealias Action = () -> Void
    static let shared = GlobalActions()
    private init() {}
    
    var exportGPX: Action?
}

