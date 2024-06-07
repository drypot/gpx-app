//
//  ContentView.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 5/28/24.
//

import SwiftUI

struct GPXEditView: View {
    
    @ObservedObject var editor: GPXEditor
    
    var body: some View {
        VStack {
            MapKitGPXEditView(editor: editor)
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
    GPXEditView(editor: GPXEditor())
}
