//
//  GPXMapViewController+MapViewDelegate.swift
//  GPXApp
//
//  Created by Kyuhyun Park on 5/16/25.
//

import Cocoa
import MapKit
import GPXAppSupport

extension GPXMapViewController: MKMapViewDelegate {

    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
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
