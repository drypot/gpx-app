//
//  ContentView.swift
//  DrypotGPX
//
//  Created by Kyuhyun Park on 5/28/24.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: Document

    var body: some View {
        SegmentView(segments: document.segments)
    }
}
#Preview {
    ContentView(document: .constant(Document()))
}
