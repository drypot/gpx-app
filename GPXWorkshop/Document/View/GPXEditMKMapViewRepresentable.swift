//
//  GPXEditMKMapViewRepresentable.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 5/11/24.
//

import SwiftUI

struct GPXEditMKMapViewRepresentable: NSViewRepresentable {
    
    @ObservedObject var document: GPXDocument
    
    func makeNSView(context: Context) -> GPXEditMKMapView {
        return GPXEditMKMapView(document)
    }

    func updateNSView(_ mapView: GPXEditMKMapView, context: Context) {
        mapView.update()
    }
    
}

#Preview {
    let document = GPXDocument()
    return GPXEditMKMapViewRepresentable(document: document)
}

