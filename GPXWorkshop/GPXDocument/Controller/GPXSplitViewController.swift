//
//  GPXSplitViewController.swift
//  HelloAppKit
//
//  Created by Kyuhyun Park on 5/3/25.
//

import Cocoa

class GPXSplitViewController: NSSplitViewController {

    override var representedObject: Any? {
        didSet {
            for child in children {
                child.representedObject = representedObject
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let sidebarController = GPXSplitViewSidebarController()
        let sidebarItem = NSSplitViewItem(sidebarWithViewController: sidebarController)
        sidebarItem.canCollapse = true
        sidebarItem.minimumThickness = 200
        sidebarItem.maximumThickness = 250
        addSplitViewItem(sidebarItem)

        let mainController = GPXViewController()
        let mainItem = NSSplitViewItem(contentListWithViewController: mainController)
        mainItem.minimumThickness = 400
        addSplitViewItem(mainItem)

        let inspectorController = GPXSplitViewInspectorController()
        let inspectorItem = NSSplitViewItem(inspectorWithViewController: inspectorController)
        inspectorItem.canCollapse = true
        inspectorItem.isCollapsed = true
        inspectorItem.minimumThickness = 200
        inspectorItem.maximumThickness = 250
        addSplitViewItem(inspectorItem)
    }

}
