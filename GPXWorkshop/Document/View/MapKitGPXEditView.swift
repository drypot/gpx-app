//
//  MapKitGPXEditView.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 5/11/24.
//

import SwiftUI

struct MapKitGPXEditView: NSViewRepresentable {
    @ObservedObject var document: GPXDocument
    
    func makeNSView(context: Context) -> MapKitGPXEditViewCore {
        return MapKitGPXEditViewCore(document)
    }

    func updateNSView(_ mapView: MapKitGPXEditViewCore, context: Context) {
        mapView.update()
    }
}

#Preview {
    let document = GPXDocument()
    return MapKitGPXEditView(document: document)
}

