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

    weak var document: GPXDocument!
    weak var viewModel: GPXViewModel!

    init() {
        gpxView = GPXView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var representedObject: Any? {
        didSet {
            document = representedObject as? GPXDocument

            viewModel = document.viewModel
            viewModel.view = gpxView

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
                deleteSelectedFileCaches()
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
        beginFileCacheSelection(at: point)
    }

    func handleShiftClick(at point: NSPoint) {
        toggleFileCacheSelection(at: point)
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
            importFiles(from: panel.urls)
        }
    }
    
    @IBAction func importSamples(_ sender: Any) {
        let urls = [URL(string: "Documents/GPX%20Files%20Subset/", relativeTo:  .currentDirectory())!]
        importFiles(from: urls)
    }
    
    public func importFiles(from urls: [URL]) {
        Task {
            do {
                var caches = [GPXFileCache]()

                // TODO: 중복 파일 임포트 방지. 먼 훗날에.
                for url in Files(urls: urls) {
                    let file = try GPXUtils.makeGPXFile(from: url)
                    caches.append(GPXFileCache(file))
                }

                await MainActor.run {
                    addFileCaches(caches)
                    gpxView.zoomToFitAllOverlays()
                }
            } catch {
                ErrorLogger.log(error)
            }
        }
    }

    @objc func addFileCaches(_ caches: [GPXFileCache]) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(removeFileCaches(_:)), object: caches)
        viewModel.addFileCaches(caches)
    }

    @objc func removeFileCaches(_ caches: [GPXFileCache]) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(addFileCaches(_:)), object: caches)
        viewModel.removeFileCaches(caches)
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

    // Delete

    @IBAction func delete(_ sender: Any?) {
        deleteSelectedFileCaches()
    }

    @objc func deleteSelectedFileCaches() {
        undoManager?.registerUndo(withTarget: self, selector: #selector(restoreSelectedFileCaches), object: viewModel.selectedFileCaches)
        viewModel.deleteSelectedFileCaches()
    }

    @objc func restoreSelectedFileCaches(_ caches: Set<GPXFileCache>) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(deleteSelectedFileCaches), object: nil)
        viewModel.restoreSelectedFileCaches(caches)
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
//            array.append(GPXBox(box.cache))
//        }
//        pasteboard.writeObjects(array)
//    }
//    
//    @objc func pastePolylines() {
//        let pasteboard = NSPasteboard.general
//        return pasteboard.readObjects(forClasses: [NSImage.self], options: nil)?.first as? NSImage
//    }

}
