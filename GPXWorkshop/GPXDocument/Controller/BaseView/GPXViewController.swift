//
//  GPXViewController.swift
//  HelloAppKit
//
//  Created by Kyuhyun Park on 5/3/25.
//

import Cocoa

class GPXViewController: NSSplitViewController {

    var sidebarController = GPXSidebarController()
    var mapViewController = GPXMapViewController()
    var inspectorController = GPXInspectorController()

    weak var document: GPXDocument?

    override var undoManager: UndoManager? {
        return document?.undoManager
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let sidebarItem = NSSplitViewItem(sidebarWithViewController: sidebarController)
        sidebarItem.canCollapse = true
        sidebarItem.minimumThickness = 200
        sidebarItem.maximumThickness = 270
        addSplitViewItem(sidebarItem)

        let mainItem = NSSplitViewItem(contentListWithViewController: mapViewController)
        mainItem.minimumThickness = 400
        addSplitViewItem(mainItem)

        let inspectorItem = NSSplitViewItem(inspectorWithViewController: inspectorController)
        inspectorItem.canCollapse = true
        inspectorItem.isCollapsed = true
        inspectorItem.minimumThickness = 200
        inspectorItem.maximumThickness = 270
        addSplitViewItem(inspectorItem)
    }

    override func viewWillAppear() {
        super.viewWillAppear()

        // viewDidLoad 에서는 windowController?.document 가 아직 세팅되지 않아서 쓸 수가 없다.
        // viewWillAppear 에서는 document 를 쓸 수 있다.

        self.document = self.view.window?.windowController?.document as? GPXDocument
        self.mapViewController.document = self.document
        self.sidebarController.document = self.document

        self.updateSubviews()
        self.mapViewController.zoomToFitAllOverlays()
    }

    @IBAction func undo(_ sender: Any?) {
        undoManager?.undo()
        updateSubviews()
    }

    @IBAction  func redo(_ sender: Any?) {
        undoManager?.redo()
        updateSubviews()
    }

    func updateSubviews() {
        mapViewController.updateOverlays()
        sidebarController.updateItems()
        document!.flushUpdated()
    }
}
