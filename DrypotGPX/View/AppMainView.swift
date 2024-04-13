//
//  ContentView.swift
//  DrypotGPX
//
//  Created by drypot on 2024-04-01.
//

import SwiftUI
import MapKit

struct AppMainView: View {
  
  var body: some View {
    MapView()
      .task(priority: .low) {
        //initGlobals()
      }
  }
  
}

var initedFlag = false

@MainActor
func initGlobals() {
  assert(!initedFlag)
  
  print("initing...")
  
  gpxManager.load()
  
  //  let currentLocation = CurrentLocation()
  //  currentLocation.run()
  
  initedFlag = true
}



#Preview {
  AppMainView()
}
