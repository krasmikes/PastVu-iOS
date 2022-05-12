//
//  Model.swift
//  PastVu
//
//  Created by Apanasenko Mikhail on 11.05.2022.
//

import Foundation

struct Photo: Codable {
    let s: Int
    let cid: Int
    let file: String
    let title: String
    let geo: [Double]
    let year: Int
    let dir: Direction

    enum Direction: String, Codable {
        case n, e, s, w, ne, se, sw, nw
    }
}
