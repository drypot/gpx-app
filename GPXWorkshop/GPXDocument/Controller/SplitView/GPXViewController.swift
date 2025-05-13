//
//  GPXViewController.swift
//  HelloAppKit
//
//  Created by Kyuhyun Park on 5/3/25.
//

import Cocoa

class GPXViewController: NSSplitViewController {

    var sidebarController: GPXSidebarController?
    var mapViewController: GPXMapViewController?
    var inspectorController: GPXInspectorController?

    weak var document: GPXDocument?

    override var undoManager: UndoManager? {
        return document!.undoManager
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        sidebarController = GPXSidebarController()
        let sidebarItem = NSSplitViewItem(sidebarWithViewController: sidebarController!)
        sidebarItem.canCollapse = true
        sidebarItem.minimumThickness = 200
        sidebarItem.maximumThickness = 250
        addSplitViewItem(sidebarItem)

        mapViewController = GPXMapViewController()
        let mainItem = NSSplitViewItem(contentListWithViewController: mapViewController!)
        mainItem.minimumThickness = 400
        addSplitViewItem(mainItem)

        inspectorController = GPXInspectorController()
        let inspectorItem = NSSplitViewItem(inspectorWithViewController: inspectorController!)
        inspectorItem.canCollapse = true
        inspectorItem.isCollapsed = true
        inspectorItem.minimumThickness = 200
        inspectorItem.maximumThickness = 250
        addSplitViewItem(inspectorItem)
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        document = self.view.window?.windowController?.document as? GPXDocument
    }

    @IBAction func undo(_ sender: Any?) {
        undoManager?.undo()
        updateViews()
    }

    @IBAction  func redo(_ sender: Any?) {
        undoManager?.redo()
        updateViews()
    }

    func updateViews() {
        mapViewController!.updateOverlays()
        sidebarController!.updateItems()
        sidebarController!.updateSelectedRows()
    }
}
