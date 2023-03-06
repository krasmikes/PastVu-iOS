//
//  PinViewModel.swift
//  PastVu
//
//  Created by Михаил Апанасенко on 01.06.22.
//

import Foundation
import UIKit

class PinViewModel {
    weak var view: PinView?
    weak var placemark: ClusterPlacemark?
    private let networkService = NetworkService.shared

    let pinType: PinType
    let id: Int
    let coordinates: Coordinate
    let direction: Direction?
    let year: Int
    let photo: String
    let count: String?
    var onPhotoDownloaded: ((UIImage) -> ())?

    init(pinType: PinType,
         id: Int,
         coordinates: Coordinate,
         direction: Direction?,
         year: Int,
         photo: String,
         count: String? = nil,
         onPhotoDownloaded: ((UIImage) -> ())? = nil
    ) {
        self.pinType = pinType
        self.id = id
        self.coordinates = coordinates
        self.direction = direction
        self.year = year
        self.photo = photo
        self.count = count
        self.onPhotoDownloaded = onPhotoDownloaded
    }

    enum PinType {
        case pin
        case cluster
    }
}
