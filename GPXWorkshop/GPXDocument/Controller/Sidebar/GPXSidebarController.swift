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

    var mainController: GPXViewController! {
        return self.parent as? GPXViewController
    }

    override func loadView() {
        view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false

        setupScrollView()
        setupTable()
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        document = self.view.window?.windowController?.document as? GPXDocument
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        updateItems()
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

    override func keyDown(with event: NSEvent) {

        // specialKey 는 macOS 13, 2022 이상에서만 지원한다고 한다.
        // 구 버전을 지원하려면 keyCode 를 써야하는데 버추얼키 정의 테이블이 없어서 숫자를 외워야 한다.

        switch event.specialKey {
        case .delete:
            deleteSelectedRows()
        default:
            super.keyDown(with: event)
        }
    }

    @objc func deleteSelectedRows() {
        let selectedRows = tableView.selectedRowIndexes
        guard !selectedRows.isEmpty else { return }

        let sortedIndexes = selectedRows.sorted(by: >)

        for index in sortedIndexes {
            items.remove(at: index)
        }

        tableView.removeRows(at: selectedRows, withAnimation: .effectFade)
    }

    func updateItems() {
        items = Array(document!.allGPXCaches).sorted()
        tableView.reloadData()
    }

    func updateSelectedRows() {
        if isUpdatingSelectedRows {
            isUpdatingSelectedRows = false
        } else {
            var selectedRows = Array<Int>()
            for (index, item) in items.enumerated() {
                if document!.selectedGPXCaches.contains(item) {
                    selectedRows.append(index)
                }
            }
            isUpdatingSelectedRows = true
            tableView.selectRowIndexes(IndexSet(selectedRows), byExtendingSelection: false)
        }
    }
}

extension GPXSidebarController: NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }

}

extension GPXSidebarController: NSTableViewDelegate {

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let id = tableColumn!.identifier
        let cell: NSTableCellView

        if let cachedCell = tableView.makeView(withIdentifier: id, owner: self) as? NSTableCellView {
            cell = cachedCell
        } else {
            cell = NSTableCellView()
            cell.identifier = id

            let textField = NSTextField()
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.isEditable = false
            textField.isBordered = false
            textField.drawsBackground = false

            cell.addSubview(textField)
            cell.textField = textField

            NSLayoutConstraint.activate([
                textField.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
                textField.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
                textField.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            ])
        }

        let item = items[row]

        switch id.rawValue {
        case "filename":
            cell.textField?.stringValue = item.filename
        default:
            break
        }

        return cell
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        if isUpdatingSelectedRows {
            isUpdatingSelectedRows = false
        } else {
            var caches: Set<GPXCache> = []
            for row in tableView.selectedRowIndexes {
                let item = items[row]
                caches.insert(item)
            }
            isUpdatingSelectedRows = true
            mainController.updateGPXSelection(to: caches)
        }
    }

}
