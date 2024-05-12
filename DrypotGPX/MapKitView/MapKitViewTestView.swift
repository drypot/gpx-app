//
//  MapKitViewTestView.swift
//  DrypotGPX
//
//  Created by Kyuhyun Park on 5/11/24.
//

import SwiftUI

struct MapKitViewTestView: View {
    
    //@StateObject var model = GPXViewModel()
    
    var body: some View {
        VStack {
            MapKitView()
            Button("Load Sample") {
                print("button update: clicked")
                //model.loadSampleTrack()
            }
        }
    }
}

#Preview {
    MapKitViewTestView()
}
