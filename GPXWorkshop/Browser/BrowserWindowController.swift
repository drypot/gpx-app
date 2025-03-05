//
//  BrowserWindowController.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 8/21/24.
//

import Cocoa

class BrowserWindowController: NSWindowController, NSWindowDelegate {

    convenience init() {
        // window 는 windowController 가 retain 하므로 따로 retain 하지 않아도 된다.
        let window = NSWindow(
            contentRect: .zero,
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )

        self.init(window: window)

        let autosaveName = "BrowserWindowFrame"

        window.title = "GPX Browser"
        window.contentViewController = BrowserController()
        window.delegate = self

        if !window.setFrameUsingName(autosaveName) {
            window.center()
        }
        window.setFrameAutosaveName(autosaveName)

//        let screen = NSScreen.main
//        let screenRect = screen?.visibleFrame ?? .zero
//        let windowSize = NSSize(width: screenRect.width * 2 / 3, height: screenRect.height * 3 / 4)
//
//        let windowRect = NSRect(
//            x: screenRect.midX - windowSize.width / 2,
//            y: screenRect.midY - windowSize.height / 2,
//            width: windowSize.width,
//            height: windowSize.height
//        )
//        self.window?.setFrame(windowRect, display: true)
    }

}
