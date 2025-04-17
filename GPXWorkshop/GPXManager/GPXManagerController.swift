//
//  GPXManagerController.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 8/20/24.
//

import Foundation
import MapKit
import Model

final class GPXManagerController: NSViewController {

    private let gpxManager: GPXManager
    private var mapView: GPXManagerMapView

    private var initialClickLocation: NSPoint?
    private var isDragging = false
    private var tolerance: CGFloat = 5.0

    init() {
        gpxManager = GPXManager()
        mapView = GPXManagerMapView(manager: gpxManager)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false

        mapView.translatesAutoresizingMaskIntoConstraints = false
        
//        mapView.keyEventDelegate = self
//        mapView.window?.makeFirstResponder(mapView)
        view.addSubview(mapView)

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(greaterThanOrEqualToConstant: 600),
            view.heightAnchor.constraint(greaterThanOrEqualToConstant: 400),

            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        // ViewController.undoManager 는 이때쯤부터 사용 가능하다.
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.makeFirstResponder(self) // 키 입력에 필요
    }

    // Key

    override var acceptsFirstResponder: Bool { true }

    override func keyDown(with event: NSEvent) {
        let characters = event.charactersIgnoringModifiers ?? ""
        for character in characters {
            switch character {
            case "\u{7F}": // delete
                delete(nil)
            default:
                break
            }
        }
    }

    // Mouse

    override func mouseDown(with event: NSEvent) {
        initialClickLocation = mapView.convert(event.locationInWindow, from: nil)
        isDragging = false
    }

    override func mouseDragged(with event: NSEvent) {
        guard let initialClickLocation = initialClickLocation else { return }

        let currentLocationInView = mapView.convert(event.locationInWindow, from: nil)

        let dx = currentLocationInView.x - initialClickLocation.x
        let dy = currentLocationInView.y - initialClickLocation.y
        let distance = sqrt(dx * dx + dy * dy)

        if distance > tolerance {
            isDragging = true
            //            handleDrag(to: currentLocationInView)
        }
    }

    override func mouseUp(with event: NSEvent) {
        if !isDragging, let initialClickLocation = initialClickLocation {
            if event.modifierFlags.contains(.shift) {
                handleShiftClick(at: initialClickLocation)
            } else {
                handleClick(at: initialClickLocation)
            }
        }
        initialClickLocation = nil
        isDragging = false
    }

    func handleClick(at point: NSPoint) {
        deselectAllAndSelect(at: point)
    }

    func handleShiftClick(at point: NSPoint) {
        toggleSelection(at: point)
    }

    // Files

    @IBAction func importFiles(_ sender: Any) {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = true
        panel.allowedContentTypes = [.gpx]
        panel.begin { [unowned self] result in
            guard result == .OK else { return }
            print(panel.urls)
            importFiles(from: panel.urls)
        }
    }
    
    @IBAction func importSamples(_ sender: Any) {
        let urls = [URL(string: "Documents/GPX%20Files%20Subset/", relativeTo:  .currentDirectory())!]
        importFiles(from: urls)
    }
    
    func importFiles(from urls: [URL]) {
        Task {
            do {
                var newFiles = [GPXFile]()

                // TODO: 중복 파일 임포트 방지. 먼 훗날에.
                for url in Files(urls: urls) {
                    let gpx = try GPXUtils.makeGPXFile(from: url)
                    newFiles.append(gpx)
                }

                await MainActor.run {
                    addFiles(newFiles)
                    mapView.zoomToFitAllOverlays()
                }
            } catch {
                ErrorLogger.log(error)
            }
        }
    }

    @objc func addFiles(_ files: [GPXFile]) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(removeFiles(_:)), object: files)
        gpxManager.addFiles(files)
    }

    @objc func removeFiles(_ files: [GPXFile]) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(addFiles(_:)), object: files)
        gpxManager.removeFiles(files)
    }

    @IBAction func exportFile(_ sender: Any) {
        fatalError("Test!")
//        let panel = NSSavePanel()
//        panel.allowedContentTypes = [.gpx]
//        panel.begin { result in
//            guard result == .OK else { return }
//            guard let url = panel.url else { return }
//            do {
//                try self.browser.data().write(to: url)
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
    }
    
/*
    public func data() throws -> Data {
        let gpx = GPXFile()
        let tracks = GPXUtils.makeGPXTracks(from: polylines)
        gpx.tracks.append(contentsOf: tracks)
        let xml = GPXExporter(gpx).makeXMLString()
        return Data(xml.utf8)
    }
*/

    // Select

    func deselectAllAndSelect(at point: NSPoint) {
        undoManager?.beginUndoGrouping()
        deselectFiles(gpxManager.selectedFiles)
        if let file = mapView.closestGPXFile(at: point) {
            selectFile(file)
        }
        undoManager?.endUndoGrouping()
    }
    
    func toggleSelection(at point: NSPoint) {
        if let file = mapView.closestGPXFile(at: point) {
            if gpxManager.selectedFiles.contains(file) {
                deselectFile(file)
            } else {
                selectFile(file)
            }
        }
    }

    @objc func selectFile(_ file: GPXFile) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(deselectFile), object: file)
        gpxManager.select(file)
    }
    
    @objc func deselectFile(_ file: GPXFile) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(selectFile), object: file)
        gpxManager.deselect(file)
    }

    @IBAction override func selectAll(_ sender: Any?) {
        selectFiles(gpxManager.unselectedFiles)
    }

    @objc func selectFiles(_ files: Set<GPXFile>) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(deselectFiles), object: files)
        gpxManager.selectFiles(files)
    }
    
    @objc func deselectFiles(_ files: Set<GPXFile>) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(selectFiles), object: files)
        gpxManager.deselectFiles(files)
    }

    // Delete

    @IBAction func delete(_ sender: Any?) {
        deleteSelected()
    }

    @objc func deleteSelected() {
        undoManager?.registerUndo(withTarget: self, selector: #selector(undeleteSelected), object: gpxManager.selectedFiles)
        gpxManager.deleteSelectedFiles()
    }

    @objc func undeleteSelected(_ files: Set<GPXFile>) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(deleteSelected), object: nil)
        gpxManager.undeleteSelectedFiles(files)
    }


    // Copy & Paste

    //
    //    @IBAction func copy(_ sender: Any) {
    //        copyPolylines()
    //    }
    //
    //    @IBAction func paste(_ sender: Any) {
    //        pastePolylines()
    //    }
    //

    @objc func copyPolylines() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        //pasteboard.writeObjects(Array(selectedPolylines))
    }
    
    @objc func pastePolylines() {
//        let pasteboard = NSPasteboard.general
//        return pasteboard.readObjects(forClasses: [NSImage.self], options: nil)?.first as? NSImage
    }

}

//extension GPXManagerController: KeyEventDelegate {
//    func handleKeyDown(with event: NSEvent, on view: NSView) -> Bool {
//        let characters = event.charactersIgnoringModifiers ?? ""
//        for character in characters {
//            switch character {
//            case "\u{7F}": // delete
//                delete(nil)
//            default:
//                return false
//            }
//        }
//        return true
//    }
//}
//
