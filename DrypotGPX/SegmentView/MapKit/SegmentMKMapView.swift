//
//  SegmentMKMapView.swift
//  DrypotGPX
//
//  Created by Kyuhyun Park on 5/24/24.
//

import Foundation
import SwiftUI
import MapKit

final class SegmentMKMapView : MKMapView {
    var viewModel: SegmentViewModel
    
    private var initialClickLocation: NSPoint?
    private var isDragging = false
    private var tolerance: CGFloat = 5.0
    
    init(_ viewModel: SegmentViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.delegate = self
        setupEventHandlers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupEventHandlers() {
//        let tapGesture = NSClickGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//        self.addGestureRecognizer(tapGesture)
    }
    
    override func mouseDown(with event: NSEvent) {
        initialClickLocation = convert(event.locationInWindow, from: nil)
        isDragging = false
    }
    
    override func mouseDragged(with event: NSEvent) {
        guard let initialClickLocation = initialClickLocation else { return }
        
        let currentLocationInView = convert(event.locationInWindow, from: nil)
        
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
        let p1 = MKMapPoint(self.convert(point, toCoordinateFrom: self))
        let p2 = MKMapPoint(self.convert(CGPoint(x: point.x + 10, y: point.y), toCoordinateFrom: self))
        let tolerance = p1.distance(to: p2)
        if let closest = viewModel.closestSegment(from: p1, tolerance: tolerance) {
            viewModel.toggleSegmentSelection(closest)
        }
    }
    
    func update() {
        viewModel.sync(with: self)
    }
    
    func zoomToFitAllOverlays() {
        var zoomRect = MKMapRect.null
        self.overlays.forEach { overlay in
            zoomRect = zoomRect.union(overlay.boundingMapRect)
        }
        if !zoomRect.isNull {
            let edgePadding = NSEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
            self.setVisibleMapRect(zoomRect, edgePadding: edgePadding, animated: false)
        }
    }
}

extension SegmentMKMapView : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            if viewModel.isSelectedSegment(polyline) {
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

struct SegmentMKMapViewRepresentable: NSViewRepresentable {
    @ObservedObject var viewModel: SegmentViewModel
    
    func makeNSView(context: Context) -> SegmentMKMapView {
        return SegmentMKMapView(viewModel)
    }

    func updateNSView(_ mapView: SegmentMKMapView, context: Context) {
        mapView.update()
    }
}

#Preview {
    let segments = SegmentViewModel()
    return SegmentMKMapViewRepresentable(viewModel: segments)
}

