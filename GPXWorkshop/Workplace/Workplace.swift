//
//  Workplace.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 8/20/24.
//

import Foundation
import MapKit

class Workplace {
    
    var polylines: Set<MKPolyline> = []
    var selectedPolylines: Set<MKPolyline> = []

    func importPolylines(_ polylines: [MKPolyline]) {
        self.polylines.formUnion(polylines)
    }
    
    func data() throws -> Data {
        var gpx = GPX()
        gpx.addTracks(from: polylines)
        let xml = GPXExporter(gpx).xml()
        return Data(xml.utf8)
    }
    
    func deleteSelected() {
        polylines.subtract(selectedPolylines)
        selectedPolylines.removeAll()
    }
    
    func undeleteSelected(_ polylines: Set<MKPolyline>) {
        self.polylines = self.polylines.union(polylines)
        selectedPolylines = polylines
    }
    
    func dumpCount() {
        print("---")
        print("polylines: \(polylines.count)")
    }

}
