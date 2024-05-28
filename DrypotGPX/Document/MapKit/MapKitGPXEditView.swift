//
//  MapKitGPXEditView.swift
//  DrypotGPX
//
//  Created by Kyuhyun Park on 5/11/24.
//

import SwiftUI

struct MapKitGPXEditView: View {
    
    @ObservedObject var segments: GPXEditModel
    
    var body: some View {
        VStack {
            SegmentMKMapViewRepresentable(viewModel: segments)
            .padding()
            .task {
                await segments.appendGPXFiles(fromDirectory: URL(fileURLWithPath: defaultGPXFolderPath))
            }
            .onAppear {
                GlobalActions.shared.exportGPX = {
                    print("export GPX!")
                }
            }
//            .contextMenu {
//                Button("Mark Start") {
//                    print("mark start")
//                }
//            }
        }
    }
}

#Preview {
    MapKitGPXEditView(segments: GPXEditModel())
}
