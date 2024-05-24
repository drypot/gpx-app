//
//  MapKitMapViewUsingNSKit.swift
//  DrypotGPX
//
//  Created by Kyuhyun Park on 5/24/24.
//

import Foundation
import SwiftUI
import MapKit

/*
 SwiftUI’s Mapping Revolution: Charting the Course with MapReader and MapProxy
 https://medium.com/@kgross144/swiftui-mapkit-anniemap-locusfocuscamera-9feba8f588ec
 */

//extension CLLocationCoordinate2D {
//    static let seoul: Self = .init(latitude: 37.5666791, longitude: 126.9782914)
//}

struct MapKitSegmentsView: NSViewRepresentable {

    @ObservedObject var segments: MapKitSegments
    
    final class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapKitSegmentsView

        init(_ parent: MapKitSegmentsView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let segments = parent.segments
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                if segments.polylineIsSelected(polyline) {
                    renderer.strokeColor = .red
                } else {
                    renderer.strokeColor = .blue
                }
                renderer.lineWidth = 3.0
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
        
        @objc func handleTap(_ gesture: NSGestureRecognizer) {
            let mapView = gesture.view as! MKMapView
            let tapPoint = gesture.location(in: mapView)
            
            let p1 = mapView.convert(tapPoint, toCoordinateFrom: mapView)
            let p2 = mapView.convert(CGPoint(x: tapPoint.x + 15, y: tapPoint.y), toCoordinateFrom: mapView)
            let radius = distanceBetween(p1, p2)

            if let closest = parent.segments.closestPolyline(at: p1, radius: radius) {
                parent.segments.togglePolylineSelection(closest)
            }
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeNSView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        let tapGesture = NSClickGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleTap(_:))
        )
        mapView.addGestureRecognizer(tapGesture)
        
        return mapView
    }

    func updateNSView(_ mapView: MKMapView, context: Context) {
        //uiView.setRegion(region, animated: true)
        mapView.removeOverlays(mapView.overlays)
        segments.addPolylines(to: mapView)
        if segments.needZoomtoFit {
            zoomToFitAllOverlays(mapView)
            segments.needZoomtoFit = false
        }
    }
    
    func zoomToFitAllOverlays(_ mapView: MKMapView) {
        var zoomRect = MKMapRect.null
        
        mapView.overlays.forEach { overlay in
            zoomRect = zoomRect.union(overlay.boundingMapRect)
        }
        
        if !zoomRect.isNull {
            let edgePadding = NSEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
            mapView.setVisibleMapRect(zoomRect, edgePadding: edgePadding, animated: false)
        }
    }
}

#Preview {
    let segments = MapKitSegments()
    return MapKitSegmentsView(segments: segments)
}

