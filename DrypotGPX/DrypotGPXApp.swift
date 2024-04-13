//
//  DrypotGPXApp.swift
//  DrypotGPX
//
//  Created by drypot on 2024-04-01.
//

import SwiftUI
import MapKit

var initedFlag = false

@main
struct DrypotGPXApp: App {
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .task(priority: .low) {
          //initGlobals()
        }
    }
  }
  
}

@MainActor
func initGlobals() {
  assert(!initedFlag)
  
  print("initing...")
  
  gpxManager.load()
  
//  let currentLocation = CurrentLocation()
//  currentLocation.run()
  
  initedFlag = true
}

