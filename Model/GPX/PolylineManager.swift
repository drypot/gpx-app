//
//  GPXManager.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 8/20/24.
//

import Foundation
import MapKit
//import Model

public class PolylineManager {

    public var polylines: Set<MKPolyline> = []
    public var selectedPolylines: Set<MKPolyline> = []

    public init() {
    }
    
    public func importPolylines(_ polylines: [MKPolyline]) {
        self.polylines.formUnion(polylines)
    }
    
    public func data() throws -> Data {
        let gpx = GPX()
        let tracks = GPX.makeGPXTracks(from: polylines)
        gpx.tracks.append(contentsOf: tracks)
        let xml = GPXExporter(gpx).makeXMLString()
        return Data(xml.utf8)
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
