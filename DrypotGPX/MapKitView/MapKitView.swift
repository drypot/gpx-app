//
//  MapKitView.swift
//  DrypotGPX
//
//  Created by Kyuhyun Park on 5/11/24.
//

import SwiftUI
import MapKit

/*
 SwiftUI’s Mapping Revolution: Charting the Course with MapReader and MapProxy
 https://medium.com/@kgross144/swiftui-mapkit-anniemap-locusfocuscamera-9feba8f588ec
 */

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
    @State var tappedCoordinate: CLLocationCoordinate2D?
    
    var body: some View {
        VStack {
            MapReader { mapProxy in
                Map {
                    ForEach(segments.segments) { segment in
                        MapPolyline(coordinates: segment.points)
                            .stroke(.blue, lineWidth: 3)
                    }
                    if let tappedCoordinate {
                        Marker("", systemImage: "pin.fill", coordinate: tappedCoordinate)
                            .tint(.purple)
                    }
                }
                .onTapGesture(coordinateSpace: .local) { location in
                    tappedCoordinate = mapProxy.convert(location, from: .local)
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

