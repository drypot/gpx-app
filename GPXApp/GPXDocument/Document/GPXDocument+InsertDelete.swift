//
//  GPXDocument+Delete.swift
//  GPXApp
//
//  Created by Kyuhyun Park on 4/26/25.
//

import Cocoa
import MapKit
import GPXAppSupport

extension GPXDocument {

    func addGPXCaches(_ caches: [GPXCache]) {
        undoManager?.registerUndo(withTarget: self) {
            $0.removeGPXCaches(caches)
        }
        allGPXCaches.formUnion(caches)
        addedGPXCaches.append(contentsOf: caches)
        for cache in caches {
            for polyline in cache.polylines {
                polylineToGPXCacheMap[polyline] = cache
            }
        }
    }

    func removeGPXCaches(_ caches: [GPXCache]) {
        undoManager?.registerUndo(withTarget: self) {
            $0.addGPXCaches(caches)
        }
        allGPXCaches.subtract(caches)
        removedGPXCaches.append(contentsOf: caches)
        for cache in caches {
            for polyline in cache.polylines {
                polylineToGPXCacheMap.removeValue(forKey: polyline)
            }
        }
    }
    
    func removeSelectedGPXCaches() {
        let selectedGPXCaches = allGPXCaches.filter { $0.isSelected }
        if !selectedGPXCaches.isEmpty {
            removeGPXCaches(Array(selectedGPXCaches))
        }
    }

}
