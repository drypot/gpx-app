//
//  WorkplaceController.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 8/20/24.
//

import Foundation
import MapKit

final class WorkplaceController: NSViewController {
    
    private var mapView: MKMapView!
    
    private var workplace = Workplace()
    
    private var initialClickLocation: NSPoint?
    private var isDragging = false
    private var tolerance: CGFloat = 5.0

    override func loadView() {
        super.loadView()
        
        mapView = MKMapView()
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        mapView.addConstrants(fill: view)

        workplace.mapView = mapView
        
//        let tapGesture = NSClickGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//        self.addGestureRecognizer(tapGesture)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func importGPX(_ sender: Any) {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = true
        panel.allowedContentTypes = [.gpx]
        panel.begin { [unowned self] result in
            guard result == .OK else { return }
            print(panel.urls)
            workplace.importGPX(from: panel.urls) {
                //
            }
        }
    }
    
    @IBAction func importGPXForTest(_ sender: Any) {
        let urls = [URL(string: "file:///Users/drypot/Library/Containers/com.drypot.GPXWorkshop/Data/Documents/GPX%20Files%20Subset/")!]
        workplace.importGPX(from: urls) {
            //
        }
    }
    
    @IBAction func exportGPX(_ sender: Any) {
        workplace.exportGPX()
    }
    
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    override func keyDown(with event: NSEvent) {
        let characters = event.charactersIgnoringModifiers ?? ""
        for character in characters {
            switch character {
            case "\u{7F}": // delete
                handleDelete()
            default:
                super.keyDown(with: event)
            }
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        initialClickLocation = mapView.convert(event.locationInWindow, from: nil)
        isDragging = false
    }
    
    override func mouseDragged(with event: NSEvent) {
        guard let initialClickLocation = initialClickLocation else { return }
        
        let currentLocationInView = mapView.convert(event.locationInWindow, from: nil)
        
        let dx = currentLocationInView.x - initialClickLocation.x
        let dy = currentLocationInView.y - initialClickLocation.y
        let distance = sqrt(dx * dx + dy * dy)
        
        if distance > tolerance {
            isDragging = true
            //handleDrag(to: currentLocationInView)
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        if !isDragging, let initialClickLocation = initialClickLocation {
            handleClick(at: initialClickLocation)
        }
        initialClickLocation = nil
        isDragging = false
    }
    
//    @objc func handleTap(_ gesture: NSGestureRecognizer) {
//        let point = gesture.location(in: self)
//        handleClick(at: point)
//    }
    
    
    func handleClick(at point: NSPoint) {
        workplace.toggleSelection(at: point)
    }
    
    func handleDelete() {
        workplace.removeSelected()
    }
    
    
}

extension WorkplaceController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            if workplace.isSelected(polyline) {
                renderer.strokeColor = .red
            } else {
                renderer.strokeColor = .blue
            }
            renderer.lineWidth = 3.0
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}
