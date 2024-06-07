//
//  MapKitGPXEditView.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 5/11/24.
//

import SwiftUI

struct MapKitGPXEditView: NSViewRepresentable {
    var editor: GPXEditor
    
    func makeNSView(context: Context) -> MapKitGPXEditViewCore {
        return MapKitGPXEditViewCore(editor)
    }

    func updateNSView(_ mapView: MapKitGPXEditViewCore, context: Context) {
        mapView.update()
    }
}

#Preview {
    let editor = GPXEditor()
    return MapKitGPXEditView(editor: editor)
}

