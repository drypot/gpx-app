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
        return document?.undoManager
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        print("baseView viewDidLoad 1")

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

        print("baseView viewDidLoad 2")
    }

    override func viewWillAppear() {
        super.viewWillAppear()

        // viewDidLoad 에서는 windowController?.document 가 아직 세팅되지 않아서 쓸 수가 없다.
        // viewWillAppear 에서는 document 를 쓸 수 있지만 추가 렌더링하기에는 너무 늦다. 아래 오류가 난다.
        // It's not legal to call -layoutSubtreeIfNeeded on a view which is already being laid out.
        // 해서 다음 이벤트 루프로 렌더링을 미루는 게 좋아보인다.

        print("baseView viewWillAppear 1")

        self.document = self.view.window?.windowController?.document as? GPXDocument
        self.mapViewController?.document = self.document
        self.sidebarController?.document = self.document

        DispatchQueue.main.async {
            print("baseView viewWillAppear 4")
            self.updateViews() // 다음 runloop cycle에서 실행됨
            self.mapViewController!.zoomToFitAllOverlays()
        }
        print("baseView viewWillAppear 3")
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
        print("GPXViewController updateViews")
        mapViewController!.updateOverlays()
        sidebarController!.updateItems()
        document!.flushUpdated()
    }
}
