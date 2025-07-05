//
//  GPXViewController+Delete.swift
//  GPXApp
//
//  Created by Kyuhyun Park on 5/9/25.
//


import Cocoa
import MapKit
import GPXAppSupport

extension GPXViewController {

    func removeSelectedGPXCaches() {
        document!.removeSelectedGPXCaches()
        updateSubviews()
    }

}
