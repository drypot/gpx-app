//
//  GPXViewController 2.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 4/26/25.
//


import Foundation
import MapKit
import GPXWorkshopSupport

extension GPXViewController {

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

    func importFiles(from urls: [URL]) {
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
                    zoomToFitAllOverlays()
                }
            } catch {
                ErrorLogger.log(error)
            }
        }
    }

    @objc func addFileCaches(_ caches: [GPXFileCache]) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(removeFileCaches(_:)), object: caches)
        addFileCachesCore(caches)
    }

    func addFileCachesCore<S: Sequence>(_ caches: S) where S.Element == GPXFileCache {
        for cache in caches {
            addFileCache(cache)
        }
    }

    func addFileCache(_ cache: GPXFileCache) {
        documentModel.allFileCaches.insert(cache)

        let polylines = cache.polylines
        for polyline in polylines {
            polylineToFileCacheMap[polyline] = cache
        }
        allPolylines.formUnion(polylines)
        mapView.addOverlays(polylines)
    }

    @objc func removeFileCaches(_ caches: [GPXFileCache]) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(addFileCaches(_:)), object: caches)
        removeFileCachesCore(caches)
    }

    func removeFileCachesCore<S: Sequence>(_ caches: S) where S.Element == GPXFileCache {
        for cache in caches {
            removeFileCache(cache)
        }
    }

    func removeFileCache(_ cache: GPXFileCache) {
        documentModel.allFileCaches.remove(cache)

        let polylines = cache.polylines
        for polyline in polylines {
            polylineToFileCacheMap.removeValue(forKey: polyline)
        }
        allPolylines.subtract(polylines)
        mapView.removeOverlays(polylines)
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

}
