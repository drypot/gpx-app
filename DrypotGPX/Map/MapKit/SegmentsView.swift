//
//  SegmentsView.swift
//  DrypotGPX
//
//  Created by Kyuhyun Park on 5/11/24.
//

import SwiftUI

struct SegmentsView: View {
    
    @StateObject var segments = SegmentsViewModel()
    
    var body: some View {
        VStack {
            SegmentsViewCore(viewModel: segments)
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
    SegmentsView()
}
