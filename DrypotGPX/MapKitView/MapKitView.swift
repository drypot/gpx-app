//
//  MapKitView.swift
//  DrypotGPX
//
//  Created by Kyuhyun Park on 5/11/24.
//

import SwiftUI
import MapKit

//extension CLLocationCoordinate2D {
//    static let seoul: Self = .init(latitude: 37.5666791, longitude: 126.9782914)
//}

struct MapKitView: View {

    //    static let initialPosition: MapCameraPosition = .userLocation(
    //        fallback: .camera(
    //            MapCamera(centerCoordinate: .seoul, distance: 3000)
    //        )
    //    )

    @StateObject var segments = MapKitSegments()
    
    var body: some View {
        VStack {
            Map {
                ForEach(segments.segments) { segment in
                    MapPolyline(coordinates: segment.points)
                        .stroke(.blue, lineWidth: 3)
                }
            }
        }
        .padding()
        .task {
            segments.loadSegments(url: URL(fileURLWithPath: defaultGPXFolderPath))
        }
    }
}

#Preview {
    //var segments = MapKitSegments()
    /*
     @State var segment: MapKitSegment = {
         var gpx = GPXManager.shared.gpxFromSampleString()
         return MapKitSegment(gpxSegment: gpx.tracks[0].segments[0])
     }()
     */
    return MapKitView(/*segments: segments*/)
}

