//
//  LocationManagerTestView.swift
//  DrypotGPX
//
//  Created by drypot on 2024-04-14.
//

import SwiftUI

struct LocationManagerTestView: View {
    
    @State var manager: LocationManager = LocationManager()
    
    var body: some View {
        Text("Test CurrentLocation")
        Button("request current location") {
            manager.requestLocation()
        }
        Button("print current location") {
            manager.logCurrent()
        }
    }
}

#Preview {
    LocationManagerTestView()
}
