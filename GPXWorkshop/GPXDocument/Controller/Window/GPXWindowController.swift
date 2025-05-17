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

            // .fullSizeContentView 중요하다.
            // 이거 빠지면 Sidebar ToolbarItem 이 구식이 된다.

            styleMask: [.titled, .closable, .resizable, .miniaturizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )

        print("GPXWindowController init")
        super.init(window: window)

        window.minSize = NSSize(width: 600, height: 400)
        window.contentViewController = GPXViewController()
        window.delegate = self
        setWindowFrame(window)

        setupToolbar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func windowDidLoad() {
        Swift.print("window did load")
    }

//    static func newContentRect() ->  NSRect {
//        let screen = NSScreen.main
//        let screenRect = screen?.visibleFrame ?? .zero
//        let contentSize = NSSize(
//            width: screenRect.width * 2 / 3,
//            height: screenRect.height * 3 / 4
//        )
//
//        if let baseWindow = NSApp.mainWindow {
//            let offset: CGFloat = 20
//            let baseFrame = baseWindow.frame
//            return NSRect(
//                x: baseFrame.origin.x + offset,
//                y: baseFrame.origin.y - offset,
//                width: baseFrame.width,
//                height: baseFrame.height
//            )
//        } else {
//            return NSRect(
//                x: screenRect.midX - contentSize.width / 2,
//                y: screenRect.midY - contentSize.height / 2,
//                width: contentSize.width,
//                height: contentSize.height
//            )
//        }
//    }

    func setWindowFrame(_ window: NSWindow) {
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

    func setupToolbar() {
        guard let window  else { fatalError() }

        let toolbar = NSToolbar(identifier: "DemoToolbar")
        toolbar.delegate = self
        toolbar.displayMode = .iconOnly

        window.toolbar = toolbar
        window.toolbarStyle = .unified
    }

    @objc func toolbarAction(_ sender: Any) {
        if  let toolbarItem = sender as? NSToolbarItem {
            print("Clicked \(toolbarItem.itemIdentifier.rawValue)")
        }
    }
}

extension NSToolbarItem.Identifier {
    static let toolbarSearchItem = NSToolbarItem.Identifier("ToolbarSearchItem")
    static let toolbarDemoTitle = NSToolbarItem.Identifier("ToolbarDemo")
}

extension GPXWindowController: NSToolbarDelegate {

    func toolbar(_ toolbar: NSToolbar,
                 itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
                 willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {

        //        if itemIdentifier == .showFonts {
        //            let item = NSToolbarItem(itemIdentifier: .showFonts)
        //            item.label = "Show fonts"
        //            item.image = NSImage(systemSymbolName: "textformat", accessibilityDescription: "Show fonts")
        //            return item
        //        }

        if  itemIdentifier == .toolbarSearchItem {
            //  `NSSearchToolbarItem` is macOS 11 and higher only
            let searchItem = NSSearchToolbarItem(itemIdentifier: itemIdentifier)
            searchItem.resignsFirstResponderWithCancel = true
            searchItem.searchField.delegate = self
            searchItem.toolTip = "Search"
            return searchItem
        }

        return nil
    }

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            .toggleSidebar,
            .sidebarTrackingSeparator,
            .flexibleSpace,
            .showFonts,
            .toolbarSearchItem,
            .inspectorTrackingSeparator,
            .toggleInspector,
        ]
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            .toggleSidebar,
            .sidebarTrackingSeparator,
            .flexibleSpace,
            .showFonts,
            .toolbarSearchItem,
            .inspectorTrackingSeparator,
            .toggleInspector,
        ]
    }

}

extension GPXWindowController: NSSearchFieldDelegate {
}
