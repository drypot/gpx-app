//
//  MapKitGPXEditView.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 5/11/24.
//

import SwiftUI

struct MapKitGPXEditView: NSViewRepresentable {
    @ObservedObject var viewModel: GPXEditModel
    
    func makeNSView(context: Context) -> MapKitGPXEditViewCore {
        return MapKitGPXEditViewCore(viewModel)
    }

    func updateNSView(_ mapView: MapKitGPXEditViewCore, context: Context) {
        mapView.update()
    }
}

#Preview {
    let segments = GPXEditModel()
    return MapKitGPXEditView(viewModel: segments)
}

