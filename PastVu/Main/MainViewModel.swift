//
//  MainViewModel.swift
//  PastVu
//
//  Created by Михаил Апанасенко on 30.05.22.
//

import Foundation

class MainViewModel {
    private let networkService = NetworkService.shared
    private let storageService = UserDefaultsManager.shared

    weak var view: MainViewController?

    var photos = [Pin]()
    var clusters: [Cluster]? = nil
    
    var provider: MapProvider
    var location: Coordinate
    var zoom: Int
    var boundingBox: BoundingBox?

    var lowerYear: Int
    var upperYear: Int

    init() {
        let mapSettings = storageService.getMapSettings()
        provider = mapSettings.provider
        location = mapSettings.location
        zoom = mapSettings.zoom

        let yearsBoundaries = storageService.getLastYearsBoundaries()
        lowerYear = yearsBoundaries.lowerYear
        upperYear = yearsBoundaries.upperYear
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

    func yearsBoundariesChanged(lowerYear: Int, upperYear: Int) {
        guard self.lowerYear != lowerYear || self.upperYear != upperYear else { return }
        
        self.lowerYear = lowerYear
        self.upperYear = upperYear

        guard let boundingBox = boundingBox else { return }

        let parameters = ByBoundsRequest.ByBoundsParameters(
            polygon: boundingBox.getPolygon(
                startFrom: .bottomLeftCounterClockWise,
                isCoordinatesReversed: true
            ),
            zoom: zoom,
            yearFrom: lowerYear,
            yearTo: upperYear,
            localWork: zoom >= 17
        )

        let request = ByBoundsRequest(params: parameters)

        networkService.request(request) { [weak self] result in
            switch result {
            case .success(let response):
                self?.updatePhotosAndClusters(photos: response.result.photos, clusters: response.result.clusters)
            case .failure(_):
                print("--- ERROR OCCURED IN MAINVIEWMODEL BYBOUNDSREQUEST ---") // обработать ошибку
            }
        }
    }

    func updatePhotosAndClusters(photos: [Pin], clusters: [Cluster]?) {
        self.photos = photos
        self.clusters = clusters
        DispatchQueue.main.async { [weak self] in
            self?.updateUI()
        }
    }

    func updateUI() {
        var pins = [PinViewModel]()
        if let clusters = clusters,
           !clusters.isEmpty {
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

    @objc func appMovedToBackground() {
        storageService.setLastYearsBoundaries((lowerYear: lowerYear, upperYear: upperYear))
    }

}

extension MainViewModel: MapViewDelegate {
    func locationChanged(withCoordinates coordinates: Coordinate, zoom: Int, boundingBox: BoundingBox) {
        self.location = coordinates
        self.zoom = zoom
        self.boundingBox = boundingBox
        
        let parameters = ByBoundsRequest.ByBoundsParameters(
            polygon: boundingBox.getPolygon(
                startFrom: .bottomLeftCounterClockWise,
                isCoordinatesReversed: true
            ),
            zoom: zoom,
            yearFrom: lowerYear,
            yearTo: upperYear,
            localWork: zoom >= 17
        )

        let request = ByBoundsRequest(params: parameters)

        networkService.request(request) { [weak self] result in
            switch result {
            case .success(let response):
                self?.updatePhotosAndClusters(photos: response.result.photos, clusters: response.result.clusters)
            case .failure(_):
                print("--- ERROR OCCURED IN MAINVIEWMODEL BYBOUNDSREQUEST ---") // обработать ошибку
            }
        }
    }

    func showPhoto(fromPin pinViewModel: PinViewModel) {
        view?.showPhoto(fromPin: pinViewModel)
    }
}
