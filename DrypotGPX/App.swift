//
//  DrypotGPXApp.swift
//  DrypotGPX
//
//  Created by drypot on 2024-04-01.
//

import SwiftUI

/*
 How to Bypass SwiftUI App Launch During Unit Testing
 https://qualitycoding.org/bypass-swiftui-app-launch-unit-testing/
 */

@main
struct MainEntryPoint {
    static func main() {
        if isTesting() {
            TestApp.main()
        } else {
            MainApp.main()
        }
    }
    private static func isTesting() -> Bool {
        return NSClassFromString("XCTestCase") != nil
    }
}

struct MainApp: App {
    var body: some Scene {
        WindowGroup {
            //LocationManagerTestView()
            MapKitSegmentsViewTestView()
        }
    }
}

struct TestApp: App {
    var body: some Scene {
        WindowGroup {
        }
    }
}
