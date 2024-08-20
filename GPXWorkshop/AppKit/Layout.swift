//
//  LayoutUtil.swift
//  Project8
//
//  Created by Kyuhyun Park on 7/11/24.
//

import Foundation
import Cocoa

extension NSView {
    
    func addConstrants(fill container: NSView, margin: CGFloat = 0) {
        self.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: margin).isActive = true
        self.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -margin).isActive = true
        self.topAnchor.constraint(equalTo: container.topAnchor, constant: margin).isActive = true
        self.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -margin).isActive = true
    }
    
    func addConstrants(fill container: NSView, after previousView: NSView, margin: CGFloat = 0 ) {
        self.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: margin).isActive = true
        self.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -margin).isActive = true
        self.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: margin).isActive = true
        self.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -margin).isActive = true
    }
    
    func addConstrants(alignTopTo other: NSView, margin: CGFloat) {
        self.topAnchor.constraint(equalTo: other.topAnchor, constant: margin).isActive = true
    }
    
    func addConstrants(alignCenterXTo other: NSView) {
        self.centerXAnchor.constraint(equalTo: other.centerXAnchor).isActive = true
    }
    
    func addConstrants(alignCenterYTo other: NSView) {
        self.centerYAnchor.constraint(equalTo: other.centerYAnchor).isActive = true
    }
    
}
