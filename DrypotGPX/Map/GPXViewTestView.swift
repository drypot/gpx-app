//
//  MapViewTestView.swift
//  DrypotGPX
//
//  Created by drypot on 2024-04-16.
//

import SwiftUI

struct GPXViewTestView: View {
    
    @StateObject var model = GPXViewModel()
    
    var body: some View {
        VStack {
            GPXView(model: model)
            Button("Load Sample") {
                print("button update: clicked")
                model.loadSampleTrack()
            }
        }
    }
}

#Preview {
    GPXViewTestView()
}
