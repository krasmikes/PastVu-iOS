//
//  Cluster.swift
//  PastVu
//
//  Created by Apanasenko Mikhail on 18.05.2022.
//

import Foundation

struct Cluster: Codable {
    let coordinates: [Double]
    let count: Int
//    let year: Year //year property is unused so far
    let preview: Photo

    enum CodingKeys: String, CodingKey {
        case coordinates = "geo"
        case count = "c"
        case preview = "p"
//        case year = "y"
    }

//    enum Year: Codable {
//
//    }
}
