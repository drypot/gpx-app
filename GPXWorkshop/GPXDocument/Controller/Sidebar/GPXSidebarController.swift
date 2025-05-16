//
//  GPXSidebarController.swift
//  HelloAppKit
//
//  Created by Kyuhyun Park on 5/3/25.
//

import Cocoa

class GPXSidebarController: NSViewController {

    weak var document: GPXDocument?

    var items = [GPXCache]()

    let scrollView = NSScrollView()
    let tableView = NSTableView()

    var isUpdatingSelectedRows = false

    var baseController: GPXViewController? {
        return self.parent as? GPXViewController
    }

    override func loadView() {
        view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false

        setupScrollView()
        setupTable()
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.hasVerticalScroller = true
        scrollView.drawsBackground = false

        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -0),
        ])
    }

    private func setupTable() {
        scrollView.documentView = tableView

        tableView.usesAutomaticRowHeights = true
        tableView.selectionHighlightStyle = .regular
        tableView.allowsMultipleSelection = true
        tableView.allowsEmptySelection = true
//        tableView.backgroundColor = .clear
        tableView.headerView = nil

        tableView.dataSource = self
        tableView.delegate = self

        let nameColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("filename"))
//        nameColumn.title = "Filename"
//        nameColumn.width = 180
        tableView.addTableColumn(nameColumn)
    }

    func updateItems() {
        if !document!.addedGPXCaches.isEmpty || !document!.removedGPXCaches.isEmpty {
            items = Array(document!.allGPXCaches).sorted()
            tableView.reloadData()
        }
        if isUpdatingSelectedRows {
            isUpdatingSelectedRows = false
        } else {
            var selectedRows = Array<Int>()
            for (index, item) in items.enumerated() {
                if item.isSelected {
                    selectedRows.append(index)
                }
            }
            isUpdatingSelectedRows = true
            tableView.selectRowIndexes(IndexSet(selectedRows), byExtendingSelection: false)
        }
    }

}

