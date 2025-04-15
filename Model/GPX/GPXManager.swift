//
//  GPXManager.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 8/20/24.
//

import Foundation
import MapKit

public protocol GPXManagerDelegate: AnyObject {
    func managerDidAddFiles(_ files: [GPXFile])
    func managerDidRemoveFiles(_ files: [GPXFile])

    func managerDidSelectFile(_ file: GPXFile)
    func managerDidDeselectFile(_ file: GPXFile)
    func managerDidSelectFiles(_ files: Set<GPXFile>)
    func managerDidDeselectFiles(_ files: Set<GPXFile>)

    func managerDidDeleteSelectedFiles()
    func managerDidUndeleteSelectedFiles(_ undoFiles: Set<GPXFile>)
}

public class GPXManager {

    public weak var delegate: GPXManagerDelegate?

    public private(set) var files: Set<GPXFile> = []
    public private(set) var selectedFiles: Set<GPXFile> = []

    public var unselectedFiles: Set<GPXFile> {
        return files.subtracting(selectedFiles)
    }

    public init() {
    }

    public func addFiles(_ filesToAdd: [GPXFile]) {
        files.formUnion(filesToAdd)
        delegate?.managerDidAddFiles(filesToAdd)
    }

    public func removeFiles(_ filesToRemove: [GPXFile]) {
        files.subtract(filesToRemove)
        delegate?.managerDidRemoveFiles(filesToRemove)
    }

    public func selectFile(_ file: GPXFile) {
        selectedFiles.insert(file)
        delegate?.managerDidSelectFile(file)
    }

    public func deselectFile(_ file: GPXFile) {
        selectedFiles.remove(file)
        delegate?.managerDidDeselectFile(file)
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
        files.subtract(selectedFiles)
        selectedFiles.removeAll()
        delegate?.managerDidDeleteSelectedFiles()
    }

    public func undeleteSelectedFiles(_ undoFiles: Set<GPXFile>) {
        files.formUnion(undoFiles)
        selectedFiles = undoFiles
        delegate?.managerDidUndeleteSelectedFiles(undoFiles)
    }

    public func dumpCount() {
        print("---")
        print("gpxFiles: \(files.count)")
    }

}
