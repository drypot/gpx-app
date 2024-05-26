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

class GlobalActions {
    typealias Action = () -> Void
    static let shared = GlobalActions()
    private init() {}
    
    var exportGPX: Action?
}

struct MainApp: App {
    var body: some Scene {
        WindowGroup {
            //LocationManagerTestView()
            SegmentsView()            
        }
        .commands {
            CommandMenu("Custom Menu") {
                Button("Export GPX") {
                    GlobalActions.shared.exportGPX?()
                }
                .keyboardShortcut("E", modifiers: [.command, .shift])
                
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                .keyboardShortcut("Q", modifiers: [.command])
            }
        }
    }
}

struct TestApp: App {
    var body: some Scene {
        WindowGroup {
        }
    }
}
