//
//  MapSettings.swift
//  PastVu
//
//  Created by Михаил Апанасенко on 30.05.22.
//

import Foundation
import CoreLocation

struct MapSettings {
    let provider: MapProvider
    let location: Coordinate
    let zoom: Int
}

enum MapProvider: String, Codable {
    case Yandex
}
