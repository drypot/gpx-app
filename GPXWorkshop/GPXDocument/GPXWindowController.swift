//
//  GPXWindowController.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 8/21/24.
//

import Cocoa

class GPXWindowController: NSWindowController, NSWindowDelegate {

    init() {
        // window 는 windowController 가 retain 하므로 따로 retain 하지 않아도 된다.
        let window = NSWindow(
            contentRect: .zero,
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )

        super.init(window: window)

//        window.title = "GPX Manager"
        window.contentViewController = GPXViewController()
        window.delegate = self
        setWindowFrame(window)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setWindowFrame(_ window: NSWindow) {
        let autosaveName = "GPXDocumentFrame_" + (document?.fileURL?.path ?? "Untitled")
        if !window.setFrameUsingName(autosaveName) {
            let screen = NSScreen.main
            let screenRect = screen?.visibleFrame ?? .zero
            let windowSize = NSSize(
                width: screenRect.width * 2 / 3,
                height: screenRect.height * 3 / 4
            )
            let windowRect = NSRect(
                x: screenRect.midX - windowSize.width / 2,
                y: screenRect.midY - windowSize.height / 2,
                width: windowSize.width,
                height: windowSize.height
            )
            window.setFrame(windowRect, display: true)
            //window.center()
        }
        window.setFrameAutosaveName(autosaveName)
    }
}
