//
//  ContentView.swift
//  DrypotGPX
//
//  Created by drypot on 2024-04-01.
//

import SwiftUI
import MapKit

struct ContentView: View {
  @State private var region = MKCoordinateRegion(
    center: CLLocationCoordinate2D(
      latitude: 37.531506,
      longitude: 127.062741
    ),
    span: MKCoordinateSpan(
      latitudeDelta: 0.2,
      longitudeDelta: 0.2
    )
  )
  
  var body: some View {
    Map(coordinateRegion: $region,
        interactionModes: .all)
  }
}

#Preview {
  ContentView()
}
