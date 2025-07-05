//
//  WorkplaceRepresentable.swift
//  GPXApp
//
//  Created by Kyuhyun Park on 5/11/24.
//

import SwiftUI

struct WorkplaceRepresentable: NSViewRepresentable {
    
    @ObservedObject var document: WorkplaceDocument
    
    func makeNSView(context: Context) -> Workplace {
        return Workplace(document)
    }

    func updateNSView(_ mapView: Workplace, context: Context) {
        mapView.update()
    }
    
}

#Preview {
    let document = WorkplaceDocument()
    return WorkplaceRepresentable(document: document)
}

