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

    func deleteSelectedGPXCaches() {
        let selectedGPXCaches = allGPXCaches.filter { $0.isSelected }
        if !selectedGPXCaches.isEmpty {
            undoManager?.registerUndo(withTarget: self) {
                $0.restoreSelectedGPXCaches(selectedGPXCaches)
            }
            allGPXCaches.subtract(selectedGPXCaches)
        }
    }

    func restoreSelectedGPXCaches(_ caches: Set<GPXCache>) {
        undoManager?.registerUndo(withTarget: self) {
            $0.deleteSelectedGPXCaches()
        }
        undoManager?.disableUndoRegistration()
        addGPXCaches(Array(caches))
        undoManager?.enableUndoRegistration()
    }

}
