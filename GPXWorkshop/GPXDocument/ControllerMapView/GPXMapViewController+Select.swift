//
//  GPXMapViewController+Select.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 5/9/25.
//

import Cocoa
import MapKit
import GPXWorkshopSupport

extension GPXMapViewController {

    @IBAction override func selectAll(_ sender: Any?) {
        document.selectGPXCaches(document.unselectedGPXCaches)
        updateOverlays()
    }

}

