//
//  LocationTestView.swift
//  DrypotGPX
//
//  Created by drypot on 2024-04-14.
//

import SwiftUI

struct LocationTestView: View {
  
  @State var manager = CurrentLocation()
  
  var body: some View {
    Text("Test CurrentLocation")
    Button("request current location") {
      manager.request()
    }
    Button("print current location") {
      manager.printCurrent()
    }
  }
}

#Preview {
  LocationTestView()
}
