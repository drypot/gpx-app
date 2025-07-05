//
//  GPXDocument+File.swift
//  GPXApp
//
//  Created by Kyuhyun Park on 5/1/25.
//

import Cocoa
import UniformTypeIdentifiers
import MapKit
import GPXAppSupport

extension GPXDocument {

    // 프로그램 종료시 저장할지 묻지 않는다.
    override var isDocumentEdited: Bool {
        return false
    }

    // KakaoMap bundle 에서 uti: public.gpx 를 등록해 놨다.
    // public 으로 시작하는 uti 는 오류라는 로그가 많이 쌓인다.
    // 기타 gpx 를 열 때 이런 저런 부작용이 발생;

    private static let _readableTypes = [
        UTType.gpxWorkshop.identifier,
        UTType.gpx.identifier,
//        UTType(filenameExtension: "gpx")!.identifier
    ]

    override class var readableTypes: [String] {
        return _readableTypes
    }

    //    override class var autosavesInPlace: Bool {
    //        return true
    //    }

    override func data(ofType typeName: String) throws -> Data {
        /*
         let gpx = GPX()
         let tracks = GPXUtils.makeGPXTracks(from: polylines)
         gpx.tracks.append(contentsOf: tracks)
         let xml = GPXExporter(gpx).makeXMLString()
         return Data(xml.utf8)
         */
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    override func read(from url: URL, ofType typeName: String) throws {
        if typeName == UTType.gpxWorkshop.identifier {
            throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        }
        let caches = try readGPXFiles(from: [url])
        undoManager?.disableUndoRegistration()
        addGPXCaches(caches)
        undoManager?.enableUndoRegistration()
    }

    func readGPXFiles(from urls: [URL]) throws -> [GPXCache] {
        var caches = [GPXCache]()

        // TODO: 중복 파일 임포트 방지. 먼 훗날에.
        for url in Files(urls: urls) {
            let cache = try GPXCache.makeGPXCache(from: url)
            caches.append(cache)
        }

        return caches
    }
}
