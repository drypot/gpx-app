//
//  GPXDocument+File.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 5/1/25.
//

import Cocoa
import UniformTypeIdentifiers
import MapKit
import GPXWorkshopSupport

extension GPXDocument {

    // 프로그램 종료시 저장할지 묻지 않는다.
    override var isDocumentEdited: Bool {
        return false
    }

    // KakaoMap 에서 public.gpx 란 아이디로 .gpx 확장자를 등록해 놔서 문제가 지저분해졌다.
    // File open dialog 에 표시되는 gpx 파일들이 com.topografix.gpx 로 인식되는 대신 public.gpx 파일들로 인식된다;
    // com.topografix.gpx 를 읽겠다고 하면 gpx 파일들을 선택할 수가 없다.
    // UTType(filenameExtension: "gpx") 식으로 UTType 을 확장자로 찾는 방법을 쓸 수 밖에 없어 보인다.
    // 이렇게 되면 read method 에서도 typeName 으로 gpx 파일을 구분할 수가 없는 문제가 있다.
    // public.gpx 가 올지, 다른 어떤 이상한 것이 올지 모르는 일이다.
    // 아무리 해도 내가 로컬로 지정한 com.topografix.gpx 는 우선순위에서 밀리는 듯하다.
    // 이것도 참 이상한 일.

    override class var readableTypes: [String] {[
        UTType.gpxWorkshop.identifier,
//        UTType.gpx.identifier,
        UTType(filenameExtension: "gpx")!.identifier
    ]}

    //    override class var autosavesInPlace: Bool {
    //        return true
    //    }

    override func data(ofType typeName: String) throws -> Data {
        //        return try workplace.data()
        //        return Data()
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    /*
     public func data() throws -> Data {
     let gpx = GPX()
     let tracks = GPXUtils.makeGPXTracks(from: polylines)
     gpx.tracks.append(contentsOf: tracks)
     let xml = GPXExporter(gpx).makeXMLString()
     return Data(xml.utf8)
     }
     */

    override func read(from data: Data, ofType typeName: String) throws {
        if typeName == UTType.gpxWorkshop.identifier {
            throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        }
        let file = try GPXUtils.makeGPX(from: data)
        let cache = GPXCache(file)
        undoManager?.disableUndoRegistration()
        addGPXCaches([cache])
        undoManager?.enableUndoRegistration()
    }

    // 이제 사용하지 않는다.
    // 여러 gpx 파일을 선택했을 때 Untitled 파일을 만들고 한번에 다 임포트하는 식으로 만들어 봤었는데
    // 아무래도 예상외의 작동에 사용자들을 놀라게 할 수 있을 것 같다.
    // 덜 놀라게 하는 방법은 수동으로 Untitle 파일을 만들고 다시 수동으로 Import 동작을 명시적으로 하도록 유도하는 게 맞을 것 같다.

//    public func loadGPXs(_ urls: [URL]) {
//        Task {
//            do {
//                var caches = [GPXCache]()
//
//                for url in Files(urls: urls) {
//                    let file = try GPXUtils.makeGPX(from: url)
//                    caches.append(GPXCache(file))
//                }
//
//                await MainActor.run {
//                    makeWindowControllers()
//                    mapViewController.addGPXCaches(caches)
//                    mapViewController.zoomToFitAllOverlays()
//                    showWindows()
//                }
//            } catch {
//                ErrorLogger.log(error)
//            }
//        }
//    }

    func gpxCaches(from urls: [URL]) throws -> [GPXCache] {
        var caches = [GPXCache]()

        // TODO: 중복 파일 임포트 방지. 먼 훗날에.
        for url in Files(urls: urls) {
            let cache = try GPXCache(url)
            caches.append(cache)
        }

        return caches
    }

//    func importFilesFromGPXCachesToLoad() {
//        if let gpxCachesToLoad {
//            undoManager?.disableUndoRegistration()
//            addGPXCaches(gpxCachesToLoad)
//            self.gpxCachesToLoad = nil
//            undoManager?.enableUndoRegistration()
//        }
//    }

    @objc func addGPXCaches(_ caches: [GPXCache]) {
        undoManager?.registerUndo(withTarget: self) {
            $0.removeCaches(caches)
        }
        for cache in caches {
            allGPXCaches.insert(cache)

            let polylines = cache.polylines
            for polyline in polylines {
                polylineToGPXCacheMap[polyline] = cache
            }
            allPolylines.formUnion(polylines)
            overlaysToAdd.append(contentsOf: polylines)
        }
    }

    @objc func removeCaches(_ caches: [GPXCache]) {
        undoManager?.registerUndo(withTarget: self) {
            $0.addGPXCaches(caches)
        }
        for cache in caches {
            allGPXCaches.remove(cache)

            let polylines = cache.polylines
            for polyline in polylines {
                polylineToGPXCacheMap.removeValue(forKey: polyline)
            }
            allPolylines.subtract(polylines)
            overlaysToRemove.append(contentsOf: polylines)
        }
    }

}
