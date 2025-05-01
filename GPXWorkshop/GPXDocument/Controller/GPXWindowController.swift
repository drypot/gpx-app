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
//        setWindowFrame(window)
        setFreshWindowFrame(window)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func windowDidLoad() {
        Swift.print("window did load")
    }

    func setFreshWindowFrame(_ window: NSWindow) {
        let screen = NSScreen.main
        let screenRect = screen?.visibleFrame ?? .zero
        let windowSize = NSSize(
            width: screenRect.width * 2 / 3,
            height: screenRect.height * 3 / 4
        )

        if let baseWindow = NSApp.mainWindow {
            let offset: CGFloat = 20
            let baseFrame = baseWindow.frame
            let windowRect = NSRect(
                x: baseFrame.origin.x + offset,
                y: baseFrame.origin.y - offset,
                width: baseFrame.width,
                height: baseFrame.height
            )
            window.setFrame(windowRect, display: true)
        } else {
            let windowRect = NSRect(
                x: screenRect.midX - windowSize.width / 2,
                y: screenRect.midY - windowSize.height / 2,
                width: windowSize.width,
                height: windowSize.height
            )
            window.setFrame(windowRect, display: true)
        }
    }

    // NSDocument window 위치는 OS 가 관리하는 것 같다.
    // 앱 다시 열면 문서 윈도우 위치가 복구된다.
    // 아래 수동 처리 안 해도 될 듯.

    func setWindowFrame(_ window: NSWindow) {
        let autosaveName = "GPXDocumentFrame_" + (document?.fileURL?.path ?? "Untitled")
        if !window.setFrameUsingName(autosaveName) {
            setFreshWindowFrame(window)
            window.setFrameAutosaveName(autosaveName)
        }
    }

}
