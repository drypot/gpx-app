//
//  ContentView.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 5/28/24.
//

import SwiftUI

struct GPXEditView: View {
    @Binding var document: GPXEditDocument
    
    var body: some View {
        VStack {
            MapKitGPXEditView(viewModel: document.segments)
            .padding()
            
//            .onAppear {
//                GlobalActions.shared.exportGPX = {
//                    print("export GPX!")
//                }
//            }
            
//            .contextMenu {
//                Button("Mark Start") {
//                    print("mark start")
//                }
//            }
        }
        
    }
}
#Preview {
    GPXEditView(document: .constant(GPXEditDocument()))
}
