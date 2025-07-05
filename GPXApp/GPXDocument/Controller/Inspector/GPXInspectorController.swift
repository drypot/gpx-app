//
//  GPXInspectorController.swift
//  HelloAppKit
//
//  Created by Kyuhyun Park on 5/3/25.
//

import Cocoa

class GPXInspectorController: NSViewController {

    weak var document: GPXDocument!

    var baseController: GPXViewController? {
        return self.parent as? GPXViewController
    }
    
    override func loadView() {
        view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
        ])
    }

}
