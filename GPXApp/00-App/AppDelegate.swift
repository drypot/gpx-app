//
//  AppDelegate.swift
//  GPXApp
//
//  Created by Kyuhyun Park on 6/12/24.
//

import Cocoa
import UniformTypeIdentifiers

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    //    var windowController = GPXManagerWindowController()

    func applicationWillFinishLaunching(_ notification: Notification) {
//        let types = UTType.types(tag: "gpx", tagClass: .filenameExtension, conformingTo: nil)
//        for type in types {
//            print(type.identifier)
//        }
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //        windowController.showWindow(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    func applicationShouldOpenUntitledFile(_ sender: NSApplication) -> Bool {
        return true
    }

    //    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
    //        return .terminateNow
    //    }

}


