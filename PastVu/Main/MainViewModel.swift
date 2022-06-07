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

    var photos = [Photo]()
    var clusters = [Cluster]()
    
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

    func updatePhotosAndClusters(photos: [Photo], clusters: [Cluster]) {
        self.photos = photos
        self.clusters = clusters
        DispatchQueue.main.async { [weak self] in
            self?.updateUI()
        }
    }

    func updateUI() {
        var pins = [PinViewModel]()
        if !clusters.isEmpty {
            pins.append(
                contentsOf: clusters.map { cluster in
                    PinViewModel(
                        pinType: .cluster,
                        id: cluster.preview.cid,
                        coordinates: Coordinate(latitude: cluster.coordinates[0], longitude: cluster.coordinates[1]),
                        direction: cluster.preview.direction,
                        year: cluster.preview.yearFrom,
                        photo: cluster.preview.filePath,
                        count: String(cluster.count)
                    )
                }
            )
        }
        if !photos.isEmpty {
            pins.append(
                contentsOf: photos.map { photo in
                    PinViewModel(
                        pinType: .pin,
                        id: photo.cid,
                        coordinates: Coordinate(latitude: photo.coordinates[0], longitude: photo.coordinates[1]),
                        direction: photo.direction,
                        year: photo.yearFrom,
                        photo: photo.filePath
                    )
                }
            )
        }

        view?.mapView.viewModel.showPins(pins)
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
                self?.updatePhotosAndClusters(photos: response.result.photos, clusters: response.result.clusters)
            case .failure(let error):
                print(error) // обработать ошибку
            }
        }
    }
}
