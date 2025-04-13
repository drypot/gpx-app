//
//  WorkplaceController.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 8/20/24.
//

import Foundation
import MapKit
import Model

final class BrowserController: NSViewController {

    private var browser = Browser()
    private var mapView = BrowserMapView()

    private var initialClickLocation: NSPoint?
    private var isDragging = false
    private var tolerance: CGFloat = 5.0

    override func loadView() {
        view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false

        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        mapView.keyEventDelegate = self
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
        mapView.addOverlays(Array(browser.polylines))
        zoomToFitAllOverlays()
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func importFiles(_ sender: Any) {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = true
        panel.allowedContentTypes = [.gpx]
        panel.begin { [unowned self] result in
            guard result == .OK else { return }
            print(panel.urls)
            importPolylines(from: panel.urls)
        }
    }
    
    @IBAction func importSamples(_ sender: Any) {
        let urls = [URL(string: "Documents/GPX%20Files%20Subset/", relativeTo:  .currentDirectory())!]
        importPolylines(from: urls)
    }
    
    func importPolylines(from urls: [URL]) {
        Task { [unowned self] in
            let polylines = try await GPX.makePolylines(from: urls)
            Task { @MainActor in
                browser.importPolylines(polylines)
                mapView.addOverlays(polylines)
                zoomToFitAllOverlays()
            }
        }
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
            //handleDrag(to: currentLocationInView)
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
        select(at: point)
    }
    
    func handleShiftClick(at point: NSPoint) {
        toggleSelection(at: point)
    }
    
    @IBAction func copy(_ sender: Any) {
        copyPolylines()
    }
    
    @IBAction func paste(_ sender: Any) {
        pastePolylines()
    }
    
    @IBAction func delete(_ sender: Any?) {
        deleteSelected()
    }
    
    @IBAction override func selectAll(_ sender: Any?) {
        selectAll()
    }
    
    // Draw
    
    func zoomToFitAllOverlays() {
        var zoomRect = MKMapRect.null
        mapView.overlays.forEach { overlay in
            zoomRect = zoomRect.union(overlay.boundingMapRect)
        }
        if !zoomRect.isNull {
            let edgePadding = NSEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
            mapView.setVisibleMapRect(zoomRect, edgePadding: edgePadding, animated: false)
        }
    }

    func redrawPolyline(_ polyline: MKPolyline) {
        mapView.removeOverlay(polyline)
        mapView.addOverlay(polyline)
    }

    func redrawPolylines(_ polylines: Set<MKPolyline>) {
        for polyline in polylines {
            mapView.removeOverlay(polyline)
            mapView.addOverlay(polyline)
        }
    }
    
    // Select
    
    func select(at point: NSPoint) {
        undoManager?.beginUndoGrouping()
        deselectAll()
        toggleSelection(at: point)
        undoManager?.endUndoGrouping()
    }
    
    func toggleSelection(at point: NSPoint) {
        if let closest = closestPolyline(from: point) {
            toggleSelection(closest)
        }
    }
    
    func toggleSelection(_ polyline: MKPolyline) {
        if browser.selectedPolylines.contains(polyline) {
            deselectPolyline(polyline)
        } else {
            selectPolyline(polyline)
        }
    }
    
    func closestPolyline(from point: NSPoint) -> MKPolyline? {
        let (mapPoint, tolerance) = mapPoint(at: point)
        var closest: MKPolyline?
        var minDistance: CLLocationDistance = .greatestFiniteMagnitude
        for polyline in browser.polylines {
            let rect = polyline.boundingMapRect.insetBy(dx: -tolerance, dy: -tolerance)
            if !rect.contains(mapPoint) {
                continue
            }
            let distance = GPX.calcDistance(from: mapPoint, to: polyline)
            if distance < tolerance, distance < minDistance {
                minDistance = distance
                closest = polyline
            }
        }
        return closest
    }
    
    func mapPoint(at point: NSPoint) -> (MKMapPoint, CLLocationDistance) {
        let limit = 10.0
        let p1 = MKMapPoint(mapView.convert(point, toCoordinateFrom: mapView))
        let p2 = MKMapPoint(mapView.convert(CGPoint(x: point.x + limit, y: point.y), toCoordinateFrom: mapView))
        let tolerance = p1.distance(to: p2)
        return (p1,tolerance)
    }
    
    @objc func selectPolyline(_ polyline: MKPolyline) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(deselectPolyline), object: polyline)
        browser.selectedPolylines.insert(polyline)
        redrawPolyline(polyline)
    }
    
    @objc func deselectPolyline(_ polyline: MKPolyline) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(selectPolyline), object: polyline)
        browser.selectedPolylines.remove(polyline)
        redrawPolyline(polyline)
    }

    @objc func selectAll() {
        undoManager?.registerUndo(withTarget: self, selector: #selector(resetSelectedPolylines), object: browser.selectedPolylines)
        let polylinesToRedraw = browser.polylines.subtracting(browser.selectedPolylines)
        browser.selectedPolylines = browser.polylines
        redrawPolylines(polylinesToRedraw)
    }
    
    @objc func deselectAll() {
        undoManager?.registerUndo(withTarget: self, selector: #selector(resetSelectedPolylines), object: browser.selectedPolylines)
        let polylinesToRedraw = browser.selectedPolylines
        browser.selectedPolylines.removeAll()
        redrawPolylines(polylinesToRedraw)
    }

    @objc func resetSelectedPolylines(_ polylines: Set<MKPolyline>) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(resetSelectedPolylines), object: browser.selectedPolylines)
        let polylinesToRedraw = browser.selectedPolylines.union(polylines)
        browser.selectedPolylines = polylines
        redrawPolylines(polylinesToRedraw)
    }
    
    // Copy & Paste
    
    @objc func copyPolylines() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        //pasteboard.writeObjects(Array(selectedPolylines))
    }
    
    @objc func pastePolylines() {
//        let pasteboard = NSPasteboard.general
//        return pasteboard.readObjects(forClasses: [NSImage.self], options: nil)?.first as? NSImage
    }
    
    // Delete
    
    @objc func deleteSelected() {
        undoManager?.registerUndo(withTarget: self, selector: #selector(undeleteSelected), object: browser.selectedPolylines)
        mapView.removeOverlays(Array(browser.selectedPolylines))
        browser.deleteSelected()
    }
    
    @objc func undeleteSelected(_ polylines: Set<MKPolyline>) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(deleteSelected), object: nil)
        mapView.addOverlays(Array(polylines))
        browser.undeleteSelected(polylines)
    }
    
}

extension BrowserController: KeyEventDelegate {
    func handleKeyDown(with event: NSEvent, on view: NSView) -> Bool {
        let characters = event.charactersIgnoringModifiers ?? ""
        for character in characters {
            switch character {
            case "\u{7F}": // delete
                delete(nil)
            default:
                return false
            }
        }
        return true
    }
}

extension BrowserController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            if browser.selectedPolylines.contains(polyline) {
                renderer.strokeColor = .red
            } else {
                renderer.strokeColor = .blue
            }
            renderer.lineWidth = 3.0
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}
