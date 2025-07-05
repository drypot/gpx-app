//
//  GPXMapViewController+Drawing.swift
//  GPXApp
//
//  Created by Kyuhyun Park on 4/26/25.
//

import Cocoa
import MapKit
import GPXAppSupport

extension GPXMapViewController {

    func updateOverlays() {
        for cache in document!.removedGPXCaches {
            mapView.removeOverlays(cache.polylines)
        }
        for cache in document!.selectionChangedGPXCaches {
            mapView.removeOverlays(cache.polylines)
        }
        for cache in document!.addedGPXCaches {
            mapView.addOverlays(cache.polylines)
        }
        for cache in document!.selectionChangedGPXCaches {
            mapView.addOverlays(cache.polylines)
        }
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

