//
//  PolylineManager.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 8/20/24.
//

import Foundation
import MapKit
import Model

class PolylineManager: NSObject {

    private let gpxManager: GPXManager
    private let mapView: GPXManagerMapView

    private var polylines: Set<MKPolyline> = []
    private var selectedPolylines: Set<MKPolyline> = []

    init(gpxManager: GPXManager, mapView: GPXManagerMapView) {
        self.gpxManager = gpxManager
        self.mapView = mapView
        super.init()
        self.mapView.delegate = self
        self.gpxManager.delegate = self
    }

    public func deleteSelected() {
        polylines.subtract(selectedPolylines)
        selectedPolylines.removeAll()
    }

    public func undeleteSelected(_ polylines: Set<MKPolyline>) {
        self.polylines = self.polylines.union(polylines)
        selectedPolylines = polylines
    }

    public func dumpCount() {
        print("---")
        print("polylines: \(polylines.count)")
    }

}

// mapView.addOverlays(Array(browser.polylines))
//         zoomToFitAllOverlays()


extension PolylineManager: GPXManagerDelegate {
    public func managerDidAddFiles(_ files: [GPXFile]) {
        var newPolylines: [MKPolyline] = []
        for file in files {
            for track in file.tracks {
                for segment in track.segments {
                    newPolylines.append(GPXUtils.makePolyline(from: segment))
                }
            }
        }
        polylines.formUnion(newPolylines)
        Task { @MainActor in
            mapView.addOverlays(newPolylines)
            mapView.zoomToFitAllOverlays()
        }
    }

    public func managerDidSelectFile(_ file: Model.GPXFile) {

    }

    public func managerDidUnselectFiles() {

    }

    public func managerDidDeleteSelectedFiles() {

    }

    public func managerDidUndeleteSelectedFiles(_ undoFiles: Set<Model.GPXFile>) {

    }


}

extension PolylineManager: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            if selectedPolylines.contains(polyline) {
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
