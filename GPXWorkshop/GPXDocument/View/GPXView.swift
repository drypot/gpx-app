//
//  GPXView.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 8/21/24.
//

import Foundation
import MapKit
import Model

public class GPXView: MKMapView {

    public weak var gpxViewModel: GPXViewModel!

    init() {
        super.init(frame: .zero)
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Drawing

    func redrawPolylines<S: Sequence>(_ polylines: S) where S.Element == MKPolyline {
        for polyline in polylines {
            redrawPolyline(polyline)
        }
    }

    func redrawPolyline(_ polyline: MKPolyline) {
        removeOverlay(polyline)
        addOverlay(polyline)
    }

    func zoomToFitAllOverlays() {
        var zoomRect = MKMapRect.null
        overlays.forEach { overlay in
            zoomRect = zoomRect.union(overlay.boundingMapRect)
        }
        if !zoomRect.isNull {
            let edgePadding = NSEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
            setVisibleMapRect(zoomRect, edgePadding: edgePadding, animated: false)
        }
    }

}

extension GPXView: MKMapViewDelegate {

    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            if let gpx = gpxViewModel.polylineToGPXMap[polyline] {
                let renderer = MKPolylineRenderer(polyline: polyline)
                if gpxViewModel.selectedFiles.contains(gpx) {
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

