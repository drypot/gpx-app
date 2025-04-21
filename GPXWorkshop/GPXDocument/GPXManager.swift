//
//  GPXManager.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 8/20/24.
//

import Foundation
import MapKit
import Model

public protocol GPXManagerDelegate: AnyObject {
    func managerDidAddGPXFiles<S: Sequence>(_ files: S) where S.Element == GPXCache
    func managerDidRemoveGPXFiles<S: Sequence>(_ files: S) where S.Element == GPXCache

    func managerDidSelectGPXFile(_ file: GPXCache)
    func managerDidDeselectGPXFile(_ file: GPXCache)

    func managerDidSelectGPXFiles(_ files: Set<GPXCache>)
    func managerDidDeselectGPXFiles(_ files: Set<GPXCache>)

    func managerDidDeleteSelectedGPXFiles<S: Sequence>(_ files: S) where S.Element == GPXCache
    func managerDidUndeleteSelectedGPXFiles<S: Sequence>(_ files: S) where S.Element == GPXCache
}

public class GPXManager {

    public weak var delegate: GPXManagerDelegate?

    public private(set) var allFiles: Set<GPXCache> = []
    public private(set) var selectedFiles: Set<GPXCache> = []

    public var unselectedFiles: Set<GPXCache> {
        return allFiles.subtracting(selectedFiles)
    }

    public init() {
    }

    public func addFiles(_ files: [GPXCache]) {
        allFiles.formUnion(files)
        delegate?.managerDidAddGPXFiles(files)
    }

    public func removeFiles(_ files: [GPXCache]) {
        allFiles.subtract(files)
        delegate?.managerDidRemoveGPXFiles(files)
    }

    public func select(_ file: GPXCache) {
        selectedFiles.insert(file)
        delegate?.managerDidSelectGPXFile(file)
    }

    public func deselect(_ file: GPXCache) {
        selectedFiles.remove(file)
        delegate?.managerDidDeselectGPXFile(file)
    }

    public func selectFiles(_ files: Set<GPXCache>) {
        selectedFiles.formUnion(files)
        delegate?.managerDidSelectGPXFiles(files)
    }

    public func deselectFiles(_ files: Set<GPXCache>) {
        selectedFiles.subtract(files)
        delegate?.managerDidDeselectGPXFiles(files)
    }

    public func deleteSelectedFiles() {
        let files = selectedFiles
        allFiles.subtract(files)
        selectedFiles.removeAll()
        delegate?.managerDidDeleteSelectedGPXFiles(files)
    }

    public func undeleteSelectedFiles(_ files: Set<GPXCache>) {
        allFiles.formUnion(files)
        selectedFiles = files
        delegate?.managerDidUndeleteSelectedGPXFiles(files)
    }

    public func dumpCount() {
        print("---")
        print("gpxFiles: \(allFiles.count)")
    }

}
