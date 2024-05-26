//
//  SegmentsViewTestView.swift
//  DrypotGPX
//
//  Created by Kyuhyun Park on 5/11/24.
//

import SwiftUI

struct SegmentsViewTestView: View {
    
    @StateObject var segments = SegmentsViewModel()
    
    var body: some View {
        VStack {
            SegmentsView(viewModel: segments)
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
    SegmentsViewTestView()
}
