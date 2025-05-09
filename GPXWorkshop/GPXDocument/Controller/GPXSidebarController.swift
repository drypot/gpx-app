//
//  GPXSidebarController.swift
//  HelloAppKit
//
//  Created by Kyuhyun Park on 5/3/25.
//

import Cocoa

class GPXSidebarController: NSViewController {

    weak var document: GPXDocument!

    override func loadView() {
        view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false

        let label = NSTextField(labelWithString: "SideBar")
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        document = self.view.window?.windowController?.document as? GPXDocument
//        document.sidebarController = self
    }
}
