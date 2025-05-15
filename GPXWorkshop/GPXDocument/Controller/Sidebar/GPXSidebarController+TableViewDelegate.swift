//
//  GPXSidebarController+TableViewDelegate.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 5/15/25.
//

import Cocoa

extension GPXSidebarController: NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }

}

extension GPXSidebarController: NSTableViewDelegate {

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let id = tableColumn!.identifier
        let cell: NSTableCellView

        if let cached = tableView.makeView(withIdentifier: id, owner: self) as? NSTableCellView {
            cell = cached
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
        print("tableViewSelectionDidChange")
        if isUpdatingSelectedRows {
            isUpdatingSelectedRows = false
        } else {
            let selectedIndexes = tableView.selectedRowIndexes

            for (index, item) in items.enumerated() {
                if item.isSelected != selectedIndexes.contains(index) {
                    if item.isSelected {
                        document!.deselectGPXCache(item)
                    } else {
                        document!.selectGPXCache(item)
                    }
                }
            }

            isUpdatingSelectedRows = true
            mainController!.updateViews()
        }
    }

}
