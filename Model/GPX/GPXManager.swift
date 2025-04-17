//
//  GPXManager.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 8/20/24.
//

import Foundation
import MapKit

public protocol GPXManagerDelegate: AnyObject {
    func managerDidAddFiles<S: Sequence>(_ files: S) where S.Element == GPXFile
    func managerDidRemoveFiles<S: Sequence>(_ files: S) where S.Element == GPXFile

    func managerDidSelect(_ file: GPXFile)
    func managerDidDeselect(_ file: GPXFile)

    func managerDidSelectFiles(_ files: Set<GPXFile>)
    func managerDidDeselectFiles(_ files: Set<GPXFile>)

    func managerDidDeleteSelectedFiles<S: Sequence>(_ files: S) where S.Element == GPXFile
    func managerDidUndeleteSelectedFiles<S: Sequence>(_ files: S) where S.Element == GPXFile
}

public class GPXManager {

    public weak var delegate: GPXManagerDelegate?

    public private(set) var allFiles: Set<GPXFile> = []
    public private(set) var selectedFiles: Set<GPXFile> = []

    public var unselectedFiles: Set<GPXFile> {
        return allFiles.subtracting(selectedFiles)
    }

    public init() {
    }

    public func addFiles(_ files: [GPXFile]) {
        allFiles.formUnion(files)
        delegate?.managerDidAddFiles(files)
    }

    public func removeFiles(_ files: [GPXFile]) {
        allFiles.subtract(files)
        delegate?.managerDidRemoveFiles(files)
    }

    public func select(_ file: GPXFile) {
        selectedFiles.insert(file)
        delegate?.managerDidSelect(file)
    }

    public func deselect(_ file: GPXFile) {
        selectedFiles.remove(file)
        delegate?.managerDidDeselect(file)
    }

    public func selectFiles(_ files: Set<GPXFile>) {
        selectedFiles.formUnion(files)
        delegate?.managerDidSelectFiles(files)
    }

    public func deselectFiles(_ files: Set<GPXFile>) {
        selectedFiles.subtract(files)
        delegate?.managerDidDeselectFiles(files)
    }

    public func deleteSelectedFiles() {
        let files = selectedFiles
        allFiles.subtract(files)
        selectedFiles.removeAll()
        delegate?.managerDidDeleteSelectedFiles(files)
    }

    public func undeleteSelectedFiles(_ files: Set<GPXFile>) {
        allFiles.formUnion(files)
        selectedFiles = files
        delegate?.managerDidUndeleteSelectedFiles(files)
    }

    public func dumpCount() {
        print("---")
        print("gpxFiles: \(allFiles.count)")
    }

}
