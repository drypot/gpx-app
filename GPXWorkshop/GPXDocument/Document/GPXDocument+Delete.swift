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
        deleteSelectedGPXCaches()
    }

    @objc func deleteSelectedGPXCaches() {
        let caches = selectedGPXCaches
        undoManager?.registerUndo(withTarget: self) {
            $0.restoreSelectedGPXCaches(caches)
        }
        selectedGPXCaches.removeAll()
        undoManager?.disableUndoRegistration()
        removeCaches(Array(caches))
        undoManager?.enableUndoRegistration()
    }

    @objc func restoreSelectedGPXCaches(_ caches: Set<GPXCache>) {
        undoManager?.registerUndo(withTarget: self) {
            $0.deleteSelectedGPXCaches()
        }
        selectedGPXCaches = caches
        undoManager?.disableUndoRegistration()
        addGPXCaches(Array(caches))
        undoManager?.enableUndoRegistration()
    }

}
