//
//  GPXViewController+Drawing.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 4/26/25.
//


import Foundation
import MapKit
import GPXWorkshopSupport

extension GPXViewController {

    func redrawPolylines<S: Sequence>(_ polylines: S) where S.Element == MKPolyline {
        for polyline in polylines {
            redrawPolyline(polyline)
        }
    }

    func redrawPolyline(_ polyline: MKPolyline) {
        mapView.removeOverlay(polyline)
        mapView.addOverlay(polyline)
    }

    func zoomToFitAllOverlays() {
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

extension GPXViewController: MKMapViewDelegate {

    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            if let gpx = document.polylineToFileCacheMap[polyline] {
                let renderer = MKPolylineRenderer(polyline: polyline)
                if document.selectedFileCaches.contains(gpx) {
                    renderer.strokeColor = .red
                } else {
                    renderer.strokeColor = .blue
                }
                renderer.lineWidth = 3.0
                return renderer
            }
        }
        return MKOverlayRenderer(overlay: overlay)
    }

}

