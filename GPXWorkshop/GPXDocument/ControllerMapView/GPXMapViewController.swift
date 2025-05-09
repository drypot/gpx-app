//
//  GPXMapViewController.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 8/20/24.
//

import Cocoa
import MapKit
import GPXWorkshopSupport

final class GPXMapViewController: NSViewController {

    weak var document: GPXDocument!

    let mapView: MKMapView

    var initialClickLocation: NSPoint?
    var isDragging = false
    var tolerance: CGFloat = 5.0

    init() {
        mapView = MKMapView()
        super.init(nibName: nil, bundle: nil)

        mapView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    override var representedObject: Any? {
//        didSet {
//            document = representedObject as? GPXDocument
//        }
//    }

    override var undoManager: UndoManager? {
        return document.undoManager
    }

    override func loadView() {
        view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false

        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mapView)

        NSLayoutConstraint.activate([
//            view.widthAnchor.constraint(greaterThanOrEqualToConstant: 600),
//            view.heightAnchor.constraint(greaterThanOrEqualToConstant: 400),

            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        document = self.view.window?.windowController?.document as? GPXDocument
//        document.mapViewController = self
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.makeFirstResponder(self) // 키 입력에 필요

//        // NSDocument 에서 다음을 호출할 적절한 이벤트가 없는 것 같다.
//        // 일단 ViewController.viewDidAppear 에서 호출하는데;
//        // 적절한 위치는 아닌 듯;
//        // GPXCache, polyline, mapView 동기화를 위한 다른 좋은 방법을 생각해 봐야;
//        document.importFilesFromGPXCachesToLoad()

        updateOverlays()
        zoomToFitAllOverlays()
    }

    @IBAction func undo(_ sender: Any?) {
        undoManager?.undo()
        updateOverlays()
    }

    @IBAction  func redo(_ sender: Any?) {
        undoManager?.redo()
        updateOverlays()
    }
}
