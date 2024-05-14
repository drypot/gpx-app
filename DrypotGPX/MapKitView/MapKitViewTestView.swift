//
//  MapKitViewTestView.swift
//  DrypotGPX
//
//  Created by Kyuhyun Park on 5/11/24.
//

import SwiftUI

struct MapKitViewTestView: View {
    
    var body: some View {
        VStack {
            MapKitView()
            Button("Load Sample") {
                print("button update: clicked")
            }
        }
    }
}

#Preview {
    MapKitViewTestView()
}
