//
//  GPXView.swift
//  DrypotGPX
//
//  Created by drypot on 2024-04-11.
//

import SwiftUI
import MapKit

struct GPXView: NSViewRepresentable {
    
    @ObservedObject var model: GPXViewModel
    
    func makeCoordinator() -> MKMapViewDelegate {
        class Delegate: NSObject, MKMapViewDelegate {
            func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
                let renderer = MKPolylineRenderer(overlay: overlay)
                renderer.strokeColor = .systemBlue
                renderer.lineWidth = 3
                return renderer
            }
        }
        return Delegate()
    }
    
    func makeNSView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        mapView.preferredConfiguration = MKStandardMapConfiguration()
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isPitchEnabled = true
        //mapView.isRotateEnabled = false
        mapView.showsCompass = true
        //mapView.showsUserLocation = true
        
        model.loadSampleTrack()
        let track = model.tracks[0]
        let line = MKPolyline(coordinates: track, count: track.count)
        mapView.addOverlay(line)
        mapView.setVisibleMapRect(
            line.boundingMapRect,
            edgePadding: NSEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
            animated: false)
        
        return mapView
    }
    
    func updateNSView(_ nsView: MKMapView, context: Context) {
        print("MapView: update")
    }
    
}

#Preview {
    StatefulObjectPreviewWrapper(GPXViewModel()) {
        GPXView(model: $0)
    }
}
