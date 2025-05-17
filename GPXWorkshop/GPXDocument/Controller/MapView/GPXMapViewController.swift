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

    let locationManager = CLLocationManager()
    let mapView = MKMapView()

    var initialClickLocation: NSPoint?
    var isDragging = false
    var tolerance: CGFloat = 5.0

    weak var document: GPXDocument?

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var baseController: GPXViewController? {
        return self.parent as? GPXViewController
    }

    override func loadView() {
        view = NSView()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        addMapView()
        self.view.window?.makeFirstResponder(self) // 키 입력에 필요
    }

    func addMapView() {
        mapView.frame = view.bounds

        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        view.addSubview(mapView)

        NSLayoutConstraint.activate([
            mapView.widthAnchor.constraint(equalTo: view.widthAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor),
//            mapView.topAnchor.constraint(equalTo: view.topAnchor),
//            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

}
