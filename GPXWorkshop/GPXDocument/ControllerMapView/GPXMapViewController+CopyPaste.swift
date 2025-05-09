//
//  GPXMapViewController+CopyPaste.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 5/9/25.
//


import Cocoa
import MapKit
import GPXWorkshopSupport

extension GPXMapViewController {

    // Copy & Paste

    //  Copy & Paset 는 XML 저장 기능 만들고 구현 가능할 것 같다.
    //
    //    @IBAction func copy(_ sender: Any) {
    //        copyPolylines()
    //    }
    //
    //    @IBAction func paste(_ sender: Any) {
    //        pastePolylines()
    //    }
    //
    //    @objc func copyPolylines() {
    //        let pasteboard = NSPasteboard.general
    //        pasteboard.clearContents()
    //        var array = [GPXBox]()
    //        for box in gpxManager.selectedFiles {
    //            array.append(GPXBox(box.cache))
    //        }
    //        pasteboard.writeObjects(array)
    //    }
    //
    //    @objc func pastePolylines() {
    //        let pasteboard = NSPasteboard.general
    //        return pasteboard.readObjects(forClasses: [NSImage.self], options: nil)?.first as? NSImage
    //    }
    
}
