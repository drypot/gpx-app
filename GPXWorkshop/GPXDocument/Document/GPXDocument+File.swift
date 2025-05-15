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

    // KakaoMap 에서 public.gpx 란 아이디로 .gpx 확장자를 등록해 놨다.
    // File open dialog 에 표시되는 gpx 파일들이 com.topografix.gpx 로 인식되는 대신 public.gpx 파일들로 인식된다;
    // com.topografix.gpx 를 읽겠다고 하면 gpx 파일들을 선택할 수가 없다.
    // UTType(filenameExtension: "gpx") 식으로 UTType 을 확장자로 찾는 방법을 쓸 수 밖에 없어 보인다.
    // 로컬에서 지정한 com.topografix.gpx 는 우선순위에서 밀리는 듯하다.
    // 이것도 참 이상한 일.

    private static let _readableTypes = [
        UTType.gpxWorkshop.identifier,
        UTType.gpx.identifier,
        //        UTType(filenameExtension: "gpx")!.identifier
    ]

    override class var readableTypes: [String] {
        Swift.print("readableTypes")
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
        Swift.print("data ofType")
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    override func read(from url: URL, ofType typeName: String) throws {
        Swift.print("read from url")
        if typeName == UTType.gpxWorkshop.identifier {
            throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        }
        let cache = try GPXCache.makeGPXCache(from: url)
        undoManager?.disableUndoRegistration()
        addGPXCaches([cache])
        undoManager?.enableUndoRegistration()
    }

    func importGPXCaches(from urls: [URL]) async throws {
        var caches = [GPXCache]()

        // TODO: 중복 파일 임포트 방지. 먼 훗날에.
        for url in Files(urls: urls) {
            Swift.print("importGPXCaches")
            Swift.print(url.absoluteString)
            let cache = try GPXCache.makeGPXCache(from: url)
            caches.append(cache)
        }

        await MainActor.run {
            addGPXCaches(caches)
        }
    }
}
