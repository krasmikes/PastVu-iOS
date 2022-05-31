//
//  MainViewModel.swift
//  PastVu
//
//  Created by Михаил Апанасенко on 30.05.22.
//

import Foundation

class MainViewModel {
    private let networkService = NetworkService.shared

    weak var view: MainViewController?
    
    var provider: MapProvider
    var location: Coordinate
    var zoom: Int

    init() {
        let mapSettings = UserDefaultsManager.shared.getMapSettings()
        provider = mapSettings.provider
        location = mapSettings.location
        zoom = mapSettings.zoom
    }

    func viewDidLoad() {
        view?.mapView.viewModel.moveToSavedLocation()
    }

    @objc func zoomInButtonTapped() {
        zoom += 1
        view?.mapView.viewModel.zoomIn()
    }

    @objc func zoomOutButtonTapped() {
        zoom -= 1
        view?.mapView.viewModel.zoomOut()
    }

    @objc func currentLocationButtonTapped() {
        view?.mapView.viewModel.moveToCurrentLocation()
    }
}

extension MainViewModel: MapViewDelegate {
    func locationChanged(withCoordinates coordinates: Coordinate, zoom: Int, boundingBox: BoundingBox) {
        self.location = coordinates
        self.zoom = zoom
        
        let parameters = ByBoundsRequest.ByBoundsParameters(
            polygon: boundingBox.getPolygon(
                startFrom: .bottomLeftCounterClockWise,
                isCoordinatesReversed: true
            ),
            zoom: zoom
        )

        let request = ByBoundsRequest(params: parameters)

        networkService.request(request) { [weak self] result in
            switch result {
            case .success(let response):
                print(response.result)
            case .failure(let error):
                print(error)
            }
        }
    }
}
