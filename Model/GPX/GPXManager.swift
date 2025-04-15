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
    func managerDidDeselectFiles()

    func managerDidDeleteSelectedFiles()
    func managerDidUndeleteSelectedFiles(_ undoFiles: Set<GPXFile>)
}

public class GPXManager {

    public weak var delegate: GPXManagerDelegate?

    private var files: Set<GPXFile> = []
    private var selectedFiles: Set<GPXFile> = []

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

    public func selectedFilesContains(_ file: GPXFile) -> Bool {
        return selectedFiles.contains(file)
    }
    
    public func selectFile(_ file: GPXFile) {
        guard files.contains(file) else {
            fatalError()
        }
        selectedFiles.insert(file)
        delegate?.managerDidSelectFile(file)
    }

    public func deselectFile(_ file: GPXFile) {
        guard files.contains(file) else {
            fatalError()
        }
        selectedFiles.remove(file)
        delegate?.managerDidDeselectFile(file)
    }

    public func deselectFiles() {
        selectedFiles.removeAll()
        delegate?.managerDidDeselectFiles()
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
