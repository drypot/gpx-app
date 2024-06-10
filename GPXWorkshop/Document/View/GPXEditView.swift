//
//  ContentView.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 5/28/24.
//

import SwiftUI

struct GPXEditView: View {
    
    @ObservedObject var document: GPXDocument
    
    var body: some View {
        VStack {
            MapKitGPXEditView(document: document)
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
    GPXEditView(document: GPXDocument())
}
