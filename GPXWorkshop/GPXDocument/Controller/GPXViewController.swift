//
//  GPXViewController.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 8/20/24.
//

import Foundation
import MapKit
import GPXWorkshopSupport

final class GPXViewController: NSViewController {

    weak var document: GPXDocument!
    weak var documentModel: GPXModel!

    var selectedFileCaches: Set<GPXFileCache> = []

    var allPolylines: Set<MKPolyline> = []
    var polylineToFileCacheMap: [MKPolyline: GPXFileCache] = [:]

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

    public var unselectedFileCaches: Set<GPXFileCache> {
        return documentModel.allFileCaches.subtracting(selectedFileCaches)
    }

    override var representedObject: Any? {
        didSet {
            document = representedObject as? GPXDocument
            documentModel = document.viewModel
        }
    }

    override func loadView() {
        view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false

        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mapView)

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(greaterThanOrEqualToConstant: 600),
            view.heightAnchor.constraint(greaterThanOrEqualToConstant: 400),

            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        // ViewController.undoManager 는 이때쯤부터 사용 가능하다.
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.makeFirstResponder(self) // 키 입력에 필요
    }

}
