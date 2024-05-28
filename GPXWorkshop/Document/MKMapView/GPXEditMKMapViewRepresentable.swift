//
//  MapKitGPXEditView.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 5/11/24.
//

import SwiftUI

struct GPXEditMKMapViewRepresentable: NSViewRepresentable {
    @ObservedObject var viewModel: GPXEditModel
    
    func makeNSView(context: Context) -> GPXEditMKMapView {
        return GPXEditMKMapView(viewModel)
    }

    func updateNSView(_ mapView: GPXEditMKMapView, context: Context) {
        mapView.update()
    }
}

#Preview {
    let segments = GPXEditModel()
    return GPXEditMKMapViewRepresentable(viewModel: segments)
}

