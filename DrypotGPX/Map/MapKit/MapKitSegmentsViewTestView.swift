//
//  MapKitSegmentsViewTestView.swift
//  DrypotGPX
//
//  Created by Kyuhyun Park on 5/11/24.
//

import SwiftUI

struct MapKitSegmentsViewTestView: View {
    
    @StateObject var segments = MapKitSegments()
    
    var body: some View {
        VStack {
            MapKitSegmentsView(segments: segments)
            .padding()
            .task {
                await segments.appendGPXFiles(fromDirectory: URL(fileURLWithPath: defaultGPXFolderPath))
            }
        }
    }
}

#Preview {
    MapKitSegmentsViewTestView()
}
