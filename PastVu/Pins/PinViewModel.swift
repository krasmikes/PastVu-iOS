//
//  PinViewModel.swift
//  PastVu
//
//  Created by Михаил Апанасенко on 01.06.22.
//

import Foundation

class PinViewModel {
    weak var view: PinView?
    private let networkService = NetworkService.shared

    let pinType: PinType
    let id: Int
    let coordinates: Coordinate
    let direction: Direction?
    let year: Int
    let photo: String
    let count: String?

    init(pinType: PinType,
         id: Int,
         coordinates: Coordinate,
         direction: Direction?,
         year: Int,
         photo: String,
         count: String? = nil
    ) {
        self.pinType = pinType
        self.id = id
        self.coordinates = coordinates
        self.direction = direction
        self.year = year
        self.photo = photo
        self.count = count
    }

    func getImage() {
        networkService.loadImage(path: photo) { result in
            switch result {
            case.success(let image):
                DispatchQueue.main.async { [weak self] in
                    self?.view?.photoView.image = image
                }
            case .failure(_):
                print("--- ERROR: COULDN'T GET PHOTO ---")
            }
        }
    }

    enum PinType {
        case pin
        case cluster
    }
}
