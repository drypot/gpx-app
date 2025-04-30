//
//  Document.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 6/12/24.
//

import Cocoa
import UniformTypeIdentifiers
import MapKit
import GPXWorkshopSupport

class GPXDocument: NSDocument {

    let documentModel: GPXDocumentModel

    weak var viewController: GPXViewController!

    override init() {
        documentModel = GPXDocumentModel()
        super.init()
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

    override func read(from data: Data, ofType typeName: String) throws {
        if typeName == UTType.gpxWorkshop.identifier {
            throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        }
        let file = try GPXUtils.makeGPXFile(from: data)
        let cache = GPXFileCache(file)
        documentModel.allFileCaches.insert(cache)
    }

    // 이제 사용하지 않는다.
    // 여러 gpx 파일을 선택했을 때 Untitled 파일을 만들고 한번에 다 임포트하는 식으로 만들어 봤었는데
    // 아무래도 예상외의 작동에 사용자들을 놀라게 할 수 있을 것 같다.
    // 덜 놀라게 하는 방법은 수동으로 Untitle 파일을 만들고 다시 수동으로 Import 동작을 명시적으로 하도록 유도하는 게 맞을 것 같다.

    public func loadGPXFiles(_ urls: [URL]) {
        Task {
            do {
                var caches = [GPXFileCache]()

                for url in Files(urls: urls) {
                    let file = try GPXUtils.makeGPXFile(from: url)
                    caches.append(GPXFileCache(file))
                }

                await MainActor.run {
                    makeWindowControllers()
                    viewController.addFileCachesCore(caches)
                    viewController.zoomToFitAllOverlays()
                    showWindows()
                }
            } catch {
                ErrorLogger.log(error)
            }
        }
    }

    // 프로그램 종료시 저장할지 묻지 않는다.
    override var isDocumentEdited: Bool {
        return false
    }

    override func makeWindowControllers() {
        let windowController = GPXWindowController()
        self.addWindowController(windowController)

        viewController = windowController.contentViewController as? GPXViewController
        viewController.representedObject = self

//        viewController.addFileCache(fileCache)
//        viewController.zoomToFitAllOverlays()

    }

}

