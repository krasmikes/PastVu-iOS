//
//  MapViewModel.swift
//  PastVu
//
//  Created by Михаил Апанасенко on 30.05.22.
//

import Foundation

class MapViewModel {
    weak var view: MapView?
    weak var delegate: MapViewDelegate?

    private let locationManager = LocationManager.shared
    private let userDefaultsManager = UserDefaultsManager.shared

    var provider: MapProvider
    var location: Coordinate
    var zoom: Float

    init(provider: MapProvider,
         location: Coordinate = Coordinate(latitude: 0, longitude: 0),
         zoom: Float = 15
    ) {
        self.provider = provider
        self.location = location
        self.zoom = zoom
    }

    @objc func appMovedToBackground() {
        userDefaultsManager.setMapSettings(
            .init(
                provider: provider,
                location: location,
                zoom: Int(zoom)
            )
        )
    }

    func moveToSavedLocation() {
        view?.moveTo(coordinates: location, zoom: zoom)
    }

    func moveToCurrentLocation() {
        locationManager.getCurrentLocation { [weak self] location in
            guard let `self` = self else { return }

            self.location = location
            self.view?.moveTo(coordinates: location, zoom: self.zoom)
        }
    }

    func zoomIn() {
        zoom += 1
        view?.moveTo(coordinates: location, zoom: zoom)
    }

    func zoomOut() {
        zoom -= 1
        view?.moveTo(coordinates: location, zoom: zoom)
    }

    func cameraPositionChanged(with boundingBox: BoundingBox, location: Coordinate, zoom: Float) {
        self.location = location
        self.zoom = zoom
        delegate?.locationChanged(withCoordinates: location, zoom: Int(zoom), boundingBox: boundingBox)
    }
}
