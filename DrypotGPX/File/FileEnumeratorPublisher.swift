//
//  FileEnumeratorPublisher.swift
//  DrypotGPX
//
//  Created by Kyuhyun Park on 5/17/24.
//

import Foundation
import Combine

/*
 Why does FileManager.enumerator use an absurd amount of memory?
 https://stackoverflow.com/questions/46383143/why-does-filemanager-enumerator-use-an-absurd-amount-of-memory
 */

func enumerateFiles2(at baseUrl: URL, handler: (URL) -> Result<Bool, Error>) -> Result<Void, Error> {
    guard let enumerator = FileManager.default.enumerator(
        at: baseUrl,
        includingPropertiesForKeys: [.isRegularFileKey],
        options: [.skipsHiddenFiles]) else {
        return .success(())
    }

    do {
        var _continue = true
        while _continue {
            try autoreleasepool {
                guard let fileURL = enumerator.nextObject() as? URL else {
                    _continue = false
                    return
                }
                let resourceValues = try fileURL.resourceValues(forKeys: [.isRegularFileKey])
                if resourceValues.isRegularFile! {
                    switch handler(fileURL) {
                    case .success(let _continue2):
                        _continue = _continue2
                    case .failure(let error):
                        throw error
                    }
                }
            }
        }
        return .success(())
    }
    catch {
        //print("Error getting resource values for \(fileURL): \(error)")
        return .failure(error)
    }
}

struct FileEnumerator: Publisher {
    typealias Output = URL
    typealias Failure = Never

    private let baseUrl: URL
    
    init(_ baseUrl: URL) {
        self.baseUrl = baseUrl
    }
    
    func receive<S: Subscriber>(subscriber: S) where S.Input == Output, S.Failure == Failure {
        
    }

}

extension FileEnumerator {
    
}
