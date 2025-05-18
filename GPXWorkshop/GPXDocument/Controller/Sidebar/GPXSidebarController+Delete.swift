//
//  GPXSidebarController+Delete.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 5/15/25.
//

import Cocoa

extension GPXSidebarController {

    func deleteSelectedRows() {
        let selectedRows = tableView.selectedRowIndexes
        if selectedRows.isEmpty {
            return
        }

        isUpdatingSelectedRows = true
        tableView.removeRows(at: selectedRows, withAnimation: .effectFade)
        isUpdatingSelectedRows = false

        baseController!.removeSelectedGPXCaches()
        baseController!.updateSubviews()
    }
    
}
