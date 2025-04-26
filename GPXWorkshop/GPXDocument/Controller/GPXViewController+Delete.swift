//
//  File 3.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 4/26/25.
//


import Foundation
import MapKit
import GPXWorkshopSupport

extension GPXViewController {

    @IBAction func delete(_ sender: Any?) {
        deleteSelectedFileCaches()
    }

    @objc func deleteSelectedFileCaches() {
        undoManager?.registerUndo(withTarget: self, selector: #selector(restoreSelectedFileCaches), object: selectedFileCaches)
        let caches = selectedFileCaches
        selectedFileCaches.removeAll()
        removeFileCachesCore(caches)
    }

    @objc func restoreSelectedFileCaches(_ caches: Set<GPXFileCache>) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(deleteSelectedFileCaches), object: nil)
        selectedFileCaches = caches
        addFileCachesCore(caches)
    }

}
