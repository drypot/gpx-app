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

    let mapView: MKMapView

    var initialClickLocation: NSPoint?
    var isDragging = false
    var tolerance: CGFloat = 5.0

    weak var document: GPXDocument!

    init() {
        mapView = MKMapView()
        super.init(nibName: nil, bundle: nil)

        mapView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var undoManager: UndoManager! {
        return document.undoManager
    }

    var mainController: GPXViewController! {
        return self.parent as? GPXViewController
    }

    override func loadView() {
        view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false

        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mapView)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        document = self.view.window?.windowController?.document as? GPXDocument
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.makeFirstResponder(self) // 키 입력에 필요
        updateOverlays()
        zoomToFitAllOverlays()
    }

}
