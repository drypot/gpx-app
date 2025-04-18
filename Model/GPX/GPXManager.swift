//
//  GPXManager.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 8/20/24.
//

import Foundation
import MapKit

public protocol GPXManagerDelegate: AnyObject {
    func managerDidAddGPXFiles<S: Sequence>(_ files: S) where S.Element == GPXFileBox
    func managerDidRemoveGPXFiles<S: Sequence>(_ files: S) where S.Element == GPXFileBox

    func managerDidSelectGPXFile(_ file: GPXFileBox)
    func managerDidDeselectGPXFile(_ file: GPXFileBox)

    func managerDidSelectGPXFiles(_ files: Set<GPXFileBox>)
    func managerDidDeselectGPXFiles(_ files: Set<GPXFileBox>)

    func managerDidDeleteSelectedGPXFiles<S: Sequence>(_ files: S) where S.Element == GPXFileBox
    func managerDidUndeleteSelectedGPXFiles<S: Sequence>(_ files: S) where S.Element == GPXFileBox
}

public class GPXManager {

    public weak var delegate: GPXManagerDelegate?

    public private(set) var allFiles: Set<GPXFileBox> = []
    public private(set) var selectedFiles: Set<GPXFileBox> = []

    public var unselectedFiles: Set<GPXFileBox> {
        return allFiles.subtracting(selectedFiles)
    }

    public init() {
    }

    public func addFiles(_ files: [GPXFileBox]) {
        allFiles.formUnion(files)
        delegate?.managerDidAddGPXFiles(files)
    }

    public func removeFiles(_ files: [GPXFileBox]) {
        allFiles.subtract(files)
        delegate?.managerDidRemoveGPXFiles(files)
    }

    public func select(_ file: GPXFileBox) {
        selectedFiles.insert(file)
        delegate?.managerDidSelectGPXFile(file)
    }

    public func deselect(_ file: GPXFileBox) {
        selectedFiles.remove(file)
        delegate?.managerDidDeselectGPXFile(file)
    }

    public func selectFiles(_ files: Set<GPXFileBox>) {
        selectedFiles.formUnion(files)
        delegate?.managerDidSelectGPXFiles(files)
    }

    public func deselectFiles(_ files: Set<GPXFileBox>) {
        selectedFiles.subtract(files)
        delegate?.managerDidDeselectGPXFiles(files)
    }

    public func deleteSelectedFiles() {
        let files = selectedFiles
        allFiles.subtract(files)
        selectedFiles.removeAll()
        delegate?.managerDidDeleteSelectedGPXFiles(files)
    }

    public func undeleteSelectedFiles(_ files: Set<GPXFileBox>) {
        allFiles.formUnion(files)
        selectedFiles = files
        delegate?.managerDidUndeleteSelectedGPXFiles(files)
    }

    public func dumpCount() {
        print("---")
        print("gpxFiles: \(allFiles.count)")
    }

}
