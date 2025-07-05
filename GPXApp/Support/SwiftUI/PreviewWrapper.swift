//
//  PreviewWrapper.swift
//  GPXApp
//
//  Created by drypot on 2024-04-16.
//

import SwiftUI

// How to preview a custom View that takes bindings as inputs in its initializer?
// https://forums.developer.apple.com/forums/thread/118589

struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content

    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        self._value = State(wrappedValue: value)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}

struct StatefulObjectPreviewWrapper<Value: ObservableObject, Content: View>: View {
    @StateObject var value: Value
    var content: (Value) -> Content

    init(_ value: Value, content: @escaping (Value) -> Content) {
        self._value = StateObject(wrappedValue: value)
        self.content = content
    }

    var body: some View {
        content(value)
    }
}
