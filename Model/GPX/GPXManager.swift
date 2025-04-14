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

    func managerDidSelectFile(_ file: GPXFile)
    func managerDidUnselectFiles()

    func managerDidDeleteSelectedFiles()
    func managerDidUndeleteSelectedFiles(_ undoFiles: Set<GPXFile>)
}

public class GPXManager {

    public weak var delegate: GPXManagerDelegate?

    private var files: Set<GPXFile> = []
    private var selectedFiles: Set<GPXFile> = []

    public init() {
    }

    public func addFiles(from urls: [URL]) async throws {
        var newFiles = [GPXFile]()

        // TODO: 중복 파일 임포트 방지. 먼 훗날에.
        for url in Files(urls: urls) {
            let gpx = try GPXUtils.makeGPXFile(from: url)
            newFiles.append(gpx)
        }
        files.formUnion(newFiles)
        delegate?.managerDidAddFiles(newFiles)
    }

    public func selectedFile(_ file: GPXFile) {
        guard files.contains(file) else {
            fatalError()
        }
        selectedFiles.insert(file)
        delegate?.managerDidSelectFile(file)
    }

    public func unselectFiles() {
        selectedFiles.removeAll()
        delegate?.managerDidUnselectFiles()
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
