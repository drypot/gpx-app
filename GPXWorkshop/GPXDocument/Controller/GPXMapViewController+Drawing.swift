//
//  GPXMapViewController+Drawing.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 4/26/25.
//


import Cocoa
import MapKit
import GPXWorkshopSupport

extension GPXMapViewController {

//    func redrawPolylines<S: Sequence>(_ polylines: S) where S.Element == MKPolyline {
//        for polyline in polylines {
//            redrawPolyline(polyline)
//        }
//    }
//
//    func redrawPolyline(_ polyline: MKPolyline) {
//        mapView.removeOverlay(polyline)
//        mapView.addOverlay(polyline)
//    }

    func updateOverlays() {
        mapView.removeOverlays(document.overlaysToRemove)
        mapView.addOverlays(document.overlaysToAdd)
        document.overlaysToRemove.removeAll()
        document.overlaysToAdd.removeAll()
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

extension GPXMapViewController: MKMapViewDelegate {

    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            if let gpx = document.polylineToGPXCacheMap[polyline] {
                let renderer = MKPolylineRenderer(polyline: polyline)
                if document.selectedGPXCaches.contains(gpx) {
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

