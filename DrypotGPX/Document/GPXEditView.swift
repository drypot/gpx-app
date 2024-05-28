//
//  ContentView.swift
//  DrypotGPX
//
//  Created by Kyuhyun Park on 5/28/24.
//

import SwiftUI

struct GPXEditView: View {
    @Binding var document: GPXEditDocument

    var body: some View {
        MapKitGPXEditView(segments: document.segments)
    }
}
#Preview {
    GPXEditView(document: .constant(GPXEditDocument()))
}
