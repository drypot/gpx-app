//
//  GPXViewController.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 8/20/24.
//

import Foundation
import MapKit
import Model

final class GPXViewController: NSViewController {

    public private(set) var gpxView: GPXView

    private var initialClickLocation: NSPoint?
    private var isDragging = false
    private var tolerance: CGFloat = 5.0

    init() {
        gpxView = GPXView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    weak var document: GPXDocument!
    weak var gpxViewModel: GPXViewModel!

    override var representedObject: Any? {
        didSet {
//            for child in children {
//                child.representedObject = representedObject
//            }
            document = representedObject as? GPXDocument
            gpxViewModel = document.viewModel
            gpxView.gpxViewModel = document.viewModel
        }
    }

    override func loadView() {
        view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false

        gpxView.translatesAutoresizingMaskIntoConstraints = false
        
//        mapView.keyEventDelegate = self
//        mapView.window?.makeFirstResponder(mapView)
        view.addSubview(gpxView)

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(greaterThanOrEqualToConstant: 600),
            view.heightAnchor.constraint(greaterThanOrEqualToConstant: 400),

            gpxView.topAnchor.constraint(equalTo: view.topAnchor),
            gpxView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gpxView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gpxView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
        initialClickLocation = gpxView.convert(event.locationInWindow, from: nil)
        isDragging = false
    }

    override func mouseDragged(with event: NSEvent) {
        guard let initialClickLocation = initialClickLocation else { return }

        let currentLocationInView = gpxView.convert(event.locationInWindow, from: nil)

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
//            print(panel.urls)
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
                var newFiles = [GPXFileCache]()

                // TODO: 중복 파일 임포트 방지. 먼 훗날에.
                for url in Files(urls: urls) {
                    let gpx = try GPXUtils.makeGPXFile(from: url)
                    newFiles.append(GPXFileCache(gpx))
                }

                await MainActor.run {
                    addFiles(newFiles)
                    gpxView.zoomToFitAllOverlays()
                }
            } catch {
                ErrorLogger.log(error)
            }
        }
    }

    @objc func addFiles(_ files: [GPXFileCache]) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(removeFiles(_:)), object: files)
        gpxViewModel.addFiles(files)
    }

    @objc func removeFiles(_ files: [GPXFileCache]) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(addFiles(_:)), object: files)
        gpxViewModel.removeFiles(files)
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
        deselectFiles(gpxViewModel.selectedFiles)
        if let file = gpxViewModel.nearestFile(to: point) {
            selectFile(file)
        }
        undoManager?.endUndoGrouping()
    }
    
    func toggleSelection(at point: NSPoint) {
        if let file = gpxViewModel.nearestFile(to: point) {
            if gpxViewModel.selectedFiles.contains(file) {
                deselectFile(file)
            } else {
                selectFile(file)
            }
        }
    }

    @objc func selectFile(_ file: GPXFileCache) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(deselectFile), object: file)
        gpxViewModel.selectFile(file)
    }
    
    @objc func deselectFile(_ file: GPXFileCache) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(selectFile), object: file)
        gpxViewModel.deselectFile(file)
    }

    @IBAction override func selectAll(_ sender: Any?) {
        selectFiles(gpxViewModel.unselectedFiles)
    }

    @objc func selectFiles(_ files: Set<GPXFileCache>) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(deselectFiles), object: files)
        gpxViewModel.selectFiles(files)
    }
    
    @objc func deselectFiles(_ files: Set<GPXFileCache>) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(selectFiles), object: files)
        gpxViewModel.deselectFiles(files)
    }

    // Delete

    @IBAction func delete(_ sender: Any?) {
        deleteSelected()
    }

    @objc func deleteSelected() {
        undoManager?.registerUndo(withTarget: self, selector: #selector(undeleteSelected), object: gpxViewModel.selectedFiles)
        gpxViewModel.deleteSelectedFiles()
    }

    @objc func undeleteSelected(_ files: Set<GPXFileCache>) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(deleteSelected), object: nil)
        gpxViewModel.undeleteSelectedFiles(files)
    }


    // Copy & Paste

//  Copy & Paset 는 XML 저장 기능 만들고 구현 가능할 것 같다.
//
//    @IBAction func copy(_ sender: Any) {
//        copyPolylines()
//    }
//
//    @IBAction func paste(_ sender: Any) {
//        pastePolylines()
//    }
//
//    @objc func copyPolylines() {
//        let pasteboard = NSPasteboard.general
//        pasteboard.clearContents()
//        var array = [GPXBox]()
//        for box in gpxManager.selectedFiles {
//            array.append(GPXBox(box.file))
//        }
//        pasteboard.writeObjects(array)
//    }
//    
//    @objc func pastePolylines() {
//        let pasteboard = NSPasteboard.general
//        return pasteboard.readObjects(forClasses: [NSImage.self], options: nil)?.first as? NSImage
//    }

}
