//
//  Box.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 4/18/25.
//

public final class Box<T> {
    public var value: T
    public init(_ value: T) {
        self.value = value
    }
}

extension Box: CustomStringConvertible {
    public var description: String {
        String(describing: value)
    }
}

extension Box: Equatable where T: Equatable {
    public static func == (lhs: Box<T>, rhs: Box<T>) -> Bool {
        lhs.value == rhs.value
    }
}

extension Box: Codable where T: Codable {
    public convenience init(from decoder: Decoder) throws {
        let value = try T(from: decoder)
        self.init(value)
    }

    public func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}
