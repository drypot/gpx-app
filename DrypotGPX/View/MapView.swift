//
//  MapView.swift
//  DrypotGPX
//
//  Created by drypot on 2024-04-11.
//

import SwiftUI
import MapKit

struct MapView: NSViewRepresentable {
    typealias NSViewType = MKMapView
    
    func makeNSView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        
        mapView.preferredConfiguration = MKStandardMapConfiguration()
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isPitchEnabled = true
        //mapView.isRotateEnabled = false
        mapView.showsCompass = true
        //mapView.showsUserLocation = true
        
        let center = mapView.userLocation.coordinate
        //let center = CLLocationCoordinate2D(latitude: 37.531506, longitude: 127.062741)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.region = region
        
        let point = MKPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: 37.531506, longitude: 127.062741)
        mapView.addAnnotation(point)
        
        return mapView
    }
    
    func updateNSView(_ nsView: MKMapView, context: Context) {
    }
    
}

#Preview {
    MapView()
}
