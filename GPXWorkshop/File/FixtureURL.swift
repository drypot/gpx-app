//
//  FixtureURL.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 6/7/24.
//

// https://forums.swift.org/t/how-can-i-access-a-file-inside-of-an-xctestcase/53424/3

import Foundation

func fixtureURL(_ fixture: String, basePath: String = #file, fixtureDirectory: String = "Fixtures") -> URL {
    return URL(fileURLWithPath: basePath)
        .deletingLastPathComponent()
        .appendingPathComponent(fixtureDirectory)
        .appendingPathComponent(fixture)
}

