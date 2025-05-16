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

    func updateOverlays() {
        print("updateOverlays 1")
        for cache in document!.removedGPXCaches {
            mapView.removeOverlays(cache.polylines)
        }
        print("updateOverlays 2")
        for cache in document!.updatedGPXCaches {
            mapView.removeOverlays(cache.polylines)
        }
        print("updateOverlays 3")
        for cache in document!.addedGPXCaches {
            mapView.addOverlays(cache.polylines)
        }
        print("updateOverlays 4")
        for cache in document!.updatedGPXCaches {
            mapView.addOverlays(cache.polylines)
        }
        print("updateOverlays 5")
    }

    func zoomToFitAllOverlays() {
        print("zoomToFitAllOverlays")
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

