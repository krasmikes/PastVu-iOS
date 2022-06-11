//
//  Photo.swift
//  PastVu
//
//  Created by Михаил Апанасенко on 07.06.22.
//

import Foundation

// Дополнить свойствами

struct Photo: Codable {
    let id: Int
    let filePath: String
    let title: String
    let description: String?
    let year: String
    let address: String?
    let coordinates: [Double]


    enum CodingKeys: String, CodingKey {
        case id = "cid"
        case description = "desc"
        case filePath = "file"
        case coordinates = "geo"
        case year = "y"
        case address, title
    }
}
