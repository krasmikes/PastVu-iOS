//
//  PinViewModel.swift
//  PastVu
//
//  Created by Михаил Апанасенко on 01.06.22.
//

import Foundation

class PinViewModel {
    let pinType: PinType
    let id: Int
    let coordinates: Coordinate
    let direction: Direction?
    let year: Int
    let photo: String

    init(pinType: PinType,
         id: Int,
         coordinates: Coordinate,
         direction: Direction?,
         year: Int,
         photo: String
    ) {
        self.pinType = pinType
        self.id = id
        self.coordinates = coordinates
        self.direction = direction
        self.year = year
        self.photo = photo
    }

    enum PinType {
        case pin
        case cluster
    }
}
