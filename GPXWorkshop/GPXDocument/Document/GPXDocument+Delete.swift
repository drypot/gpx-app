//
//  GPXDocument+Delete.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 4/26/25.
//


import Foundation
import MapKit
import GPXWorkshopSupport

extension GPXDocument {

    @IBAction func delete(_ sender: Any?) {
        deleteSelectedFileCaches()
    }

    @objc func deleteSelectedFileCaches() {
        let caches = selectedCaches
        undoManager?.registerUndo(withTarget: self) {
            $0.restoreSelectedFileCaches(caches)
        }
        selectedCaches.removeAll()
        undoManager?.disableUndoRegistration()
        removeFileCaches(Array(caches))
        undoManager?.enableUndoRegistration()
    }

    @objc func restoreSelectedFileCaches(_ caches: Set<GPXCache>) {
        undoManager?.registerUndo(withTarget: self) {
            $0.deleteSelectedFileCaches()
        }
        selectedCaches = caches
        undoManager?.disableUndoRegistration()
        addFileCaches(Array(caches))
        undoManager?.enableUndoRegistration()
    }

}
