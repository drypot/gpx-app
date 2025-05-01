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
        let caches = selectedFileCaches
        undoManager?.registerUndo(withTarget: self) {
            $0.restoreSelectedFileCaches(caches)
        }
        selectedFileCaches.removeAll()
        undoManager?.disableUndoRegistration()
        removeFileCaches(Array(caches))
        undoManager?.enableUndoRegistration()
    }

    @objc func restoreSelectedFileCaches(_ caches: Set<GPXFileCache>) {
        undoManager?.registerUndo(withTarget: self) {
            $0.deleteSelectedFileCaches()
        }
        selectedFileCaches = caches
        undoManager?.disableUndoRegistration()
        addFileCaches(Array(caches))
        undoManager?.enableUndoRegistration()
    }

}
