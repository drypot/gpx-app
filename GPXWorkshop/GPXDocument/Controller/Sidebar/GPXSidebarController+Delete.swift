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

//        let sortedIndexes = selectedRows.sorted(by: >)
//        for index in sortedIndexes {
//            items.remove(at: index)
//        }
        tableView.removeRows(at: selectedRows, withAnimation: .effectFade)

        baseController!.removeSelectedGPXCaches()
    }
    
}
