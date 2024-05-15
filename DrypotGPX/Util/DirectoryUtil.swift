//
//  DirectoryUtil.swift
//  DrypotGPX
//
//  Created by Kyuhyun Park on 5/16/24.
//

import Foundation

/*
 Why does FileManager.enumerator use an absurd amount of memory?
 https://stackoverflow.com/questions/46383143/why-does-filemanager-enumerator-use-an-absurd-amount-of-memory
 */

func enumerateRegularFiles(at baseUrl: URL, limit: Int = 0, handler: (URL) -> Void) {
    let fileManager = FileManager.default
    var count = 0
    
    guard let enumerator = fileManager.enumerator(
        at: baseUrl,
        includingPropertiesForKeys: [.isRegularFileKey],
        options: [.skipsHiddenFiles]) else {
        return
    }
    
    var done = false
    while !done {
        autoreleasepool {
            guard let fileURL = enumerator.nextObject() as? URL else {
                done = true
                return
            }
            do {
                let resourceValues = try fileURL.resourceValues(forKeys: [.isRegularFileKey])
                if resourceValues.isRegularFile! {
                    handler(fileURL)
                    count += 1
                    done = count == limit
                }
            } catch {
                print("Error getting resource values for \(fileURL): \(error)")
                done = true
                return
            }
        }
    }
}
