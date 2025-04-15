//
//  FileUtil.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 5/16/24.
//

import Foundation
import Combine

/*
 Why does FileManager.enumerator use an absurd amount of memory?
 https://stackoverflow.com/questions/46383143/why-does-filemanager-enumerator-use-an-absurd-amount-of-memory
 */

/*
 Files Sequence
 */

public struct Files: Sequence  {

    static let defaultResourceKeys: [URLResourceKey] = [.isRegularFileKey, .isDirectoryKey]
    static let defaultResourceKeysSet: Set<URLResourceKey> = Set(defaultResourceKeys)
    static let defaultOptions: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles]
    
    private let urls: [URL]
    
    public init(urls: [URL]) {
        self.urls = urls
    }
    
    public init(url: URL) {
        self.urls = [url]
    }
    
    public func makeIterator() -> Self.Iterator {
        return Iterator(urls: self.urls)
    }
    
    public struct Iterator: IteratorProtocol {
        private var urls: [URL]
        private var enumerator: FileManager.DirectoryEnumerator?

        init(urls: [URL]) {
            self.urls = urls
        }
        
        public mutating func next() -> URL? {
            do {
                if enumerator == nil {
                    if urls.isEmpty {
                        return nil
                    }
                    let url = urls.removeFirst()
                    let resourceValues = try url.resourceValues(forKeys: defaultResourceKeysSet)
                    if resourceValues.isRegularFile! {
                        return url
                    }
                    if resourceValues.isDirectory! {
                        enumerator = FileManager.default.enumerator(
                            at: url,
                            includingPropertiesForKeys: defaultResourceKeys,
                            options: defaultOptions
                        )
                    }
                    return next()
                }
                guard let url = enumerator!.nextObject() as? URL else {
                    self.enumerator = nil
                    return next()
                }
                let resourceValues = try url.resourceValues(forKeys: defaultResourceKeysSet)
                if resourceValues.isRegularFile! {
                    return url
                }
                return next()
            } catch {
                return nil
            }
        }
    }
    
}

/*
 use Result
 */

public func enumerateFiles(url: URL, handler: (URL) -> Result<Bool, Error>) -> Result<Void, Error> {
    guard let enumerator = FileManager.default.enumerator(
        at: url,
        includingPropertiesForKeys: [.isRegularFileKey],
        options: [.skipsHiddenFiles]) else {
        return .success(())
    }

    do {
        var _continue = true
        let resourceKeys: Set<URLResourceKey> = [.isRegularFileKey]
        while _continue {
            try autoreleasepool {
                guard let fileURL = enumerator.nextObject() as? URL else {
                    _continue = false
                    return
                }
                let resourceValues = try fileURL.resourceValues(forKeys: resourceKeys)
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
    } catch {
        //print("Error getting resource values for \(fileURL): \(error)")
        return .failure(error)
    }
}

/*
 Combine Publisher
 */

public struct FilesPublisher: Publisher {
    public typealias Output = URL
    public typealias Failure = Never
    let url: URL

    public init(url: URL) {
        self.url = url
    }
    
    public func receive<S: Subscriber>(subscriber: S) where S.Input == Output, S.Failure == Failure {
        let subscription = Subscription(url: url, subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}

private extension FilesPublisher {
    final class Subscription<S: Subscriber>: Combine.Subscription where S.Input == Output, S.Failure == Failure {
        
        private let enumerator: FileManager.DirectoryEnumerator?
        private var subscriber: S?
        
        init(url: URL, subscriber: S) {
            self.subscriber = subscriber
            self.enumerator = FileManager.default.enumerator(
                at: url,
                includingPropertiesForKeys: [.isRegularFileKey],
                options: [.skipsHiddenFiles]
            )
        }
        
        func request(_ demand: Subscribers.Demand) {
            guard let enumerator else {
                subscriber?.receive(completion: .finished)
                return
            }

            do {
                var _continue = true
                var demand = demand
                let resourceKeys: Set<URLResourceKey> = [.isRegularFileKey]
                while let subscriber = subscriber, demand > 0, _continue {
                    try autoreleasepool {
                        guard let fileURL = enumerator.nextObject() as? URL else {
                            subscriber.receive(completion: .finished)
                            _continue = false
                            return
                        }
                        let resourceValues = try fileURL.resourceValues(forKeys: resourceKeys)
                        if resourceValues.isRegularFile! {
                            demand -= 1
                            demand += subscriber.receive(fileURL)
                        }
                    }
                }
            }
            catch {
                //print("Error getting resource values for \(fileURL): \(error)")
                subscriber?.receive(completion: .finished)
            }
        }
        
        func cancel() {
            subscriber = nil
        }
    }
}

