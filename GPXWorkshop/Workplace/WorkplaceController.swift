//
//  WorkplaceController.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 8/20/24.
//

import Foundation
import MapKit

final class WorkplaceController: NSViewController {

    private weak var workplace: Workplace!

    private var mapView: WorkplaceMapView!
    
    private var initialClickLocation: NSPoint?
    private var isDragging = false
    private var tolerance: CGFloat = 5.0


    var document: Document {
        return view.window?.windowController?.document as! Document
    }
    
    override func loadView() {
        super.loadView()
        
        mapView = WorkplaceMapView()
        mapView.delegate = self
        mapView.keyEventDelegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        mapView.addConstrants(fill: view)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        // ViewController.undoManager 는 이때쯤부터 사용 가능하다.
        workplace = document.workplace
        workplace.mapView = mapView
        workplace.undoManager = undoManager
        if let dataToLoad = document.dataToLoad {
            do {
                try workplace.importGPX(from: dataToLoad)
                document.dataToLoad = nil
            } catch {
                print(error.localizedDescription)
            }
        }
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
            workplace.importGPX(from: panel.urls) {
                //
            }
        }
    }
    
    @IBAction func importSamples(_ sender: Any) {
        let urls = [URL(string: "Documents/GPX%20Files%20Subset/", relativeTo:  .currentDirectory())!]
        workplace.importGPX(from: urls) {
            //
        }
    }
    
    @IBAction func exportFile(_ sender: Any) {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.gpx]
        panel.begin { result in
            guard result == .OK else { return }
            guard let url = panel.url else { return }
            do {
                try self.workplace.export(to: url)
            } catch {
                print(error.localizedDescription)
            }
        }
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
        workplace.select(at: point)
    }
    
    func handleShiftClick(at point: NSPoint) {
        workplace.toggleSelection(at: point)
    }
    
    @IBAction func copy(_ sender: Any) {
        workplace.copyPolylines()
    }
    
    @IBAction func paste(_ sender: Any) {
        workplace.pastePolylines()
    }
    
    @IBAction func delete(_ sender: Any?) {
        workplace.deleteSelected()
    }
    
    @IBAction override func selectAll(_ sender: Any?) {
        workplace.selectAll()
    }
}

extension WorkplaceController: KeyEventDelegate {
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

extension WorkplaceController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            if workplace.isSelected(polyline) {
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
