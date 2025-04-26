//
//  File.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 4/26/25.
//


import Foundation
import MapKit
import GPXWorkshopSupport

extension GPXViewController {

    // Select

    @IBAction override func selectAll(_ sender: Any?) {
        selectFileCaches(viewModel.unselectedFileCaches)
    }

    func beginFileCacheSelection(at point: NSPoint) {
        undoManager?.beginUndoGrouping()
        deselectFileCaches(viewModel.selectedFileCaches)
        if let cache = viewModel.nearestFileCache(to: point) {
            selectFileCache(cache)
        }
        undoManager?.endUndoGrouping()
    }

    func toggleFileCacheSelection(at point: NSPoint) {
        if let cache = viewModel.nearestFileCache(to: point) {
            if viewModel.selectedFileCaches.contains(cache) {
                deselectFileCache(cache)
            } else {
                selectFileCache(cache)
            }
        }
    }

    @objc func selectFileCache(_ cache: GPXFileCache) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(deselectFileCache), object: cache)
        viewModel.selectFileCache(cache)
    }

    @objc func deselectFileCache(_ cache: GPXFileCache) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(selectFileCache), object: cache)
        viewModel.deselectFileCache(cache)
    }

    @objc func selectFileCaches(_ caches: Set<GPXFileCache>) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(deselectFileCaches), object: caches)
        viewModel.selectFileCaches(caches)
    }

    @objc func deselectFileCaches(_ caches: Set<GPXFileCache>) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(selectFileCaches), object: caches)
        viewModel.deselectFileCaches(caches)
    }

}
