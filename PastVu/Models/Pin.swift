//
//  Model.swift
//  PastVu
//
//  Created by Apanasenko Mikhail on 11.05.2022.
//

import Foundation

struct Pin: Codable {
    let s: Int?
    let cid: Int
    let filePath: String
    let title: String
    let coordinates: [Double]
    let yearFrom: Int
    let yearTo: Int
    let direction: Direction?

    enum CodingKeys: String, CodingKey {
        case s, cid, title
        case filePath = "file"
        case direction = "dir"
        case coordinates = "geo"
        case yearFrom = "year"
        case yearTo = "year2"
    }
}
