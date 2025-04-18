//
//  GPXManager.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 8/20/24.
//

import Foundation
import MapKit

public protocol GPXManagerDelegate: AnyObject {
    func managerDidAddFiles<S: Sequence>(_ files: S) where S.Element == GPXBox
    func managerDidRemoveFiles<S: Sequence>(_ files: S) where S.Element == GPXBox

    func managerDidSelect(_ file: GPXBox)
    func managerDidDeselect(_ file: GPXBox)

    func managerDidSelectFiles(_ files: Set<GPXBox>)
    func managerDidDeselectFiles(_ files: Set<GPXBox>)

    func managerDidDeleteSelectedFiles<S: Sequence>(_ files: S) where S.Element == GPXBox
    func managerDidUndeleteSelectedFiles<S: Sequence>(_ files: S) where S.Element == GPXBox
}

public class GPXManager {

    public weak var delegate: GPXManagerDelegate?

    public private(set) var allFiles: Set<GPXBox> = []
    public private(set) var selectedFiles: Set<GPXBox> = []

    public var unselectedFiles: Set<GPXBox> {
        return allFiles.subtracting(selectedFiles)
    }

    public init() {
    }

    public func addFiles(_ files: [GPXBox]) {
        allFiles.formUnion(files)
        delegate?.managerDidAddFiles(files)
    }

    public func removeFiles(_ files: [GPXBox]) {
        allFiles.subtract(files)
        delegate?.managerDidRemoveFiles(files)
    }

    public func select(_ file: GPXBox) {
        selectedFiles.insert(file)
        delegate?.managerDidSelect(file)
    }

    public func deselect(_ file: GPXBox) {
        selectedFiles.remove(file)
        delegate?.managerDidDeselect(file)
    }

    public func selectFiles(_ files: Set<GPXBox>) {
        selectedFiles.formUnion(files)
        delegate?.managerDidSelectFiles(files)
    }

    public func deselectFiles(_ files: Set<GPXBox>) {
        selectedFiles.subtract(files)
        delegate?.managerDidDeselectFiles(files)
    }

    public func deleteSelectedFiles() {
        let files = selectedFiles
        allFiles.subtract(files)
        selectedFiles.removeAll()
        delegate?.managerDidDeleteSelectedFiles(files)
    }

    public func undeleteSelectedFiles(_ files: Set<GPXBox>) {
        allFiles.formUnion(files)
        selectedFiles = files
        delegate?.managerDidUndeleteSelectedFiles(files)
    }

    public func dumpCount() {
        print("---")
        print("gpxFiles: \(allFiles.count)")
    }

}
