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
                .focusedSceneValue(\.activeGPXDocument, document)
            Button("Debug Info") {
                document.dumpDebugInfo()
            }
        }
    }
    
}

struct ActiveGPXDocumentKey: FocusedValueKey {
  typealias Value = GPXDocument
}

extension FocusedValues {
  var activeGPXDocument: GPXDocument? {
    get { self[ActiveGPXDocumentKey.self] }
    set { self[ActiveGPXDocumentKey.self] = newValue }
  }
}

#Preview {
    GPXEditView(document: GPXDocument())
}
