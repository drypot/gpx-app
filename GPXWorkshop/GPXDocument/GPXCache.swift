//
//  GPXCache.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 4/21/25.
//

import Foundation
import MapKit
import Model

public final class GPXCache: NSObject {

    public var file: GPXFile

    public init(_ file: GPXFile) {
        self.file = file
    }

    public override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Self else { return false }
        return self === other
    }

    public override var hash: Int {
        return ObjectIdentifier(self).hashValue
    }

    public override var description: String {
        String(describing: file)
    }
}
