//
//  GPXMapViewController+MapViewDelegate.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 5/16/25.
//

import Cocoa
import MapKit
import GPXWorkshopSupport

extension GPXMapViewController: MKMapViewDelegate {

    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        print("mapView rendererFor")
        if let polyline = overlay as? MKPolyline {
            if let cache = document!.polylineToGPXCacheMap[polyline] {
                let renderer = MKPolylineRenderer(polyline: polyline)
                if cache.isSelected {
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
