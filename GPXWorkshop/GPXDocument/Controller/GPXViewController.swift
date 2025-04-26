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

    let gpxView: GPXView

    var initialClickLocation: NSPoint?
    var isDragging = false
    var tolerance: CGFloat = 5.0

    weak var document: GPXDocument!
    weak var viewModel: GPXModel!

    init() {
        gpxView = GPXView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var representedObject: Any? {
        didSet {
            document = representedObject as? GPXDocument

            viewModel = document.viewModel
            viewModel.view = gpxView

            gpxView.gpxViewModel = document.viewModel
        }
    }

    override func loadView() {
        view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false

        gpxView.translatesAutoresizingMaskIntoConstraints = false
        
//        mapView.keyEventDelegate = self
//        mapView.window?.makeFirstResponder(mapView)
        view.addSubview(gpxView)

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(greaterThanOrEqualToConstant: 600),
            view.heightAnchor.constraint(greaterThanOrEqualToConstant: 400),

            gpxView.topAnchor.constraint(equalTo: view.topAnchor),
            gpxView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gpxView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gpxView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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

    func zoomToFitAllOverlays() {
        gpxView.zoomToFitAllOverlays()
    }

}
