//
//  Direction.swift
//  PastVu
//
//  Created by Apanasenko Mikhail on 18.05.2022.
//

import Foundation

enum Direction: String {
    case n, e, s, w, ne, se, sw, nw, aero
    case unknown
}

extension Direction: Codable {
    public init(from decoder: Decoder) throws {
        self = try Direction(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}
