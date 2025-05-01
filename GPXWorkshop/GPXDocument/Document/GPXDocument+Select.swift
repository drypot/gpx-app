//
//  GPXDocument+Select.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 4/26/25.
//

import Foundation
import MapKit
import GPXWorkshopSupport

extension GPXDocument {

    @IBAction func selectAll(_ sender: Any?) {
        selectFileCaches(unselectedFileCaches)
    }

    func beginFileCacheSelection(at point: NSPoint) {
        undoManager?.beginUndoGrouping()
        if let cache = viewController?.nearestFileCache(to: point) {
            if selectedFileCaches.contains(cache) {
                deselectFileCaches(selectedFileCaches)
            } else {
                deselectFileCaches(selectedFileCaches)
                selectFileCache(cache)
            }
        }
        undoManager?.endUndoGrouping()
    }

    func toggleFileCacheSelection(at point: NSPoint) {
        if let cache = viewController?.nearestFileCache(to: point) {
            if selectedFileCaches.contains(cache) {
                deselectFileCache(cache)
            } else {
                selectFileCache(cache)
            }
        }
    }

    @objc func selectFileCaches(_ caches: Set<GPXFileCache>) {
        undoManager?.registerUndo(withTarget: self) {
            $0.deselectFileCaches(caches)
        }
        for cache in caches {
            selectFileCacheCore(cache)
        }
    }

    @objc func selectFileCache(_ cache: GPXFileCache) {
        undoManager?.registerUndo(withTarget: self) {
            $0.deselectFileCache(cache)
        }
        selectFileCacheCore(cache)
    }

    func selectFileCacheCore(_ cache: GPXFileCache) {
        selectedFileCaches.insert(cache)
        viewController?.redrawPolylines(cache.polylines)
    }

    @objc func deselectFileCaches() {
        deselectFileCaches(selectedFileCaches)
    }

    @objc func deselectFileCaches(_ caches: Set<GPXFileCache>) {
        undoManager?.registerUndo(withTarget: self) {
            $0.selectFileCaches(caches)
        }
        for cache in caches {
            deselectFileCacheCore(cache)
        }
    }

    @objc func deselectFileCache(_ cache: GPXFileCache) {
        undoManager?.registerUndo(withTarget: self) {
            $0.selectFileCache(cache)
        }
        deselectFileCacheCore(cache)
    }

    func deselectFileCacheCore(_ cache: GPXFileCache) {
        selectedFileCaches.remove(cache)
        viewController?.redrawPolylines(cache.polylines)
    }

}
