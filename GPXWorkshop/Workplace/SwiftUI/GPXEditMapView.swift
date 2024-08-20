//
//  MapKitSegmentsView Experimental.swift
//  GPXWorkshop
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

struct GPXEditMapView: View {

    //    static let initialPosition: MapCameraPosition = .userLocation(
    //        fallback: .camera(
    //            MapCamera(centerCoordinate: .seoul, distance: 3000)
    //        )
    //    )

    @ObservedObject var document: WorkplaceDocument
    
//    @StateObject var segments = MapKitSegments()
//    @State var tappedCoordinate: CLLocationCoordinate2D?
    
    var body: some View {
        VStack {
            MapReader { mapProxy in
                Map {
//                    ForEach(document.segments)
                    
//                    ForEach(segments.segments) { segment in
//                        MapPolyline(coordinates: segment.points)
//                            .stroke(segment.isSelected ? .red : .blue, lineWidth: 3)
//                    }
                }
                .onTapGesture { location in
//                    let p1 = mapProxy.convert(location, from: .local)!
//                    let p2 = mapProxy.convert(CGPoint(x: location.x + 15, y: location.y), from: .local)!
//                    let radius = distanceBetween(p1, p2)
//                    //tappedCoordinate = point
//                    let closest = segments.closestSegment(at: p1, radius: radius)
//                    closest?.toggleSelected()
                }
            }
            Button("Action") {
//                print(segments.selection)
            }
        }
        .padding()
        .task {
            //segments.appendGPXFilesRecursivelySync(fromDirectory: URL(fileURLWithPath: defaultGPXFolderPath))
//            await segments.appendGPXFiles(fromDirectory: URL(fileURLWithPath: defaultGPXFolderPath))
        }
    }
}

//#Preview {
//    //var segments = MapKitSegments()
//    /*
//     @State var segment: MapKitSegment = {
//         var gpx = GPXManager.shared.gpxFromSampleString()
//         return MapKitSegment(gpxSegment: gpx.tracks[0].segments[0])
//     }()
//     */
//    return GPXEditMapView(/*segments: segments*/)
//}
//
