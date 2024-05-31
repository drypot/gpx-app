//
//  Globals.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 5/16/24.
//

import Foundation

let defaultGPXFolderPath = "Documents/GPX Files"

class GlobalActions {
    typealias Action = () -> Void
    static let shared = GlobalActions()
    private init() {}
    
    var exportGPX: Action?
}
