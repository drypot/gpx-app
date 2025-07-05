//
//  ContentView.swift
//  GPXApp
//
//  Created by Kyuhyun Park on 5/28/24.
//

import SwiftUI

struct GPXEditView: View {
    
    @ObservedObject var document: WorkplaceDocument
    
    var body: some View {
        VStack {
            WorkplaceRepresentable(document: document)
                .focusedSceneValue(\.activeGPXDocument, document)
            Button("Debug Info") {
                document.dumpDebugInfo()
            }
        }
    }
    
}

struct ActiveGPXDocumentKey: FocusedValueKey {
  typealias Value = WorkplaceDocument
}

extension FocusedValues {
  var activeGPXDocument: WorkplaceDocument? {
    get { self[ActiveGPXDocumentKey.self] }
    set { self[ActiveGPXDocumentKey.self] = newValue }
  }
}

#Preview {
    GPXEditView(document: WorkplaceDocument())
}
