//
//  Polygon.swift
//  PastVu
//
//  Created by Apanasenko Mikhail on 19.05.2022.
//

import Foundation

struct Polygon: Codable {
    let type: PolygonType
    let coordinates: [[[Double]]]

    enum PolygonType: String, Codable {
        case polygon = "Polygon"
        case multiPolygon = "MultiPolygon"
    }
}
