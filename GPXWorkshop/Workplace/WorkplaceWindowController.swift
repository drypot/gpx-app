//
//  WorkplaceWindowController.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 8/21/24.
//

import Cocoa

class WorkplaceWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        
        let screen = NSScreen.main
        let screenRect = screen?.visibleFrame ?? .zero
        let windowSize = NSSize(width: screenRect.width * 2 / 3, height: screenRect.height * 3 / 4)

        let windowRect = NSRect(
            x: screenRect.midX - windowSize.width / 2,
            y: screenRect.midY - windowSize.height / 2,
            width: windowSize.width,
            height: windowSize.height
        )
        self.window?.setFrame(windowRect, display: true)
    }

}
