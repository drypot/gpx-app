//
//  GPXViewController+Select.swift
//  GPXApp
//
//  Created by Kyuhyun Park on 5/9/25.
//

import Cocoa
import MapKit
import GPXAppSupport

extension GPXViewController {

    @IBAction override func selectAll(_ sender: Any?) {
        document!.selectAllGPXCaches()
        updateSubviews()
    }

    func beginGPXSelection(at mapPoint: MKMapPoint, with tolerance: CLLocationDistance) {
        document!.beginGPXSelection(at: mapPoint, with: tolerance)
        updateSubviews()
    }

    func toggleGPXSelection(at mapPoint: MKMapPoint, with tolerance: CLLocationDistance) {
        document!.toggleGPXSelection(at: mapPoint, with: tolerance)
        updateSubviews()
    }

}

