//
//  MapKitGPXEditView.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 5/11/24.
//

import SwiftUI

struct MapKitGPXEditView: NSViewRepresentable {
    var segments: Segments
    
    func makeNSView(context: Context) -> MapKitGPXEditViewCore {
        return MapKitGPXEditViewCore(segments)
    }

    func updateNSView(_ mapView: MapKitGPXEditViewCore, context: Context) {
        mapView.update()
    }
}

#Preview {
    let segments = Segments()
    return MapKitGPXEditView(segments: segments)
}

