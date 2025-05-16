//
//  GPXViewController+Delete.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 5/9/25.
//


import Cocoa
import MapKit
import GPXWorkshopSupport

extension GPXViewController {

    func removeSelectedGPXCaches() {
        document!.removeSelectedGPXCaches()
        updateViews()
    }

}
