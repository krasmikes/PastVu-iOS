//
//  YandexMapView.swift
//  PastVu
//
//  Created by Apanasenko Mikhail on 16.05.2022.
//

import Foundation
import YandexMapsMobile
import CoreLocation

class YandexMapView: UIView, MapView {
    var viewModel: MapViewModel
    var currentPins = [PinView]()

#if targetEnvironment(simulator)
    private let view = YMKMapView(frame: .zero, vulkanPreferred: true)!
#else
    private let view = YMKMapView(frame: .zero)
#endif

    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder: NSCoder) {
        viewModel = MapViewModel(provider: .Yandex)
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        viewModel.view = self
        NotificationCenter.default.addObserver(viewModel, selector: "appMovedToBackground", name: UIApplication.willResignActiveNotification, object: nil)

        view.mapWindow.map.addCameraListener(with: self)
        view.mapWindow.map.isTiltGesturesEnabled = false
        view.mapWindow.map.isRotateGesturesEnabled = false

        [
            view
        ].forEach { addSubview($0) }

        [
            view
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        [
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),

        ].forEach { $0.isActive = true }
    }

    func moveTo(coordinates: Coordinate, zoom: Float) {
        let point = YMKPoint(latitude: coordinates.latitude, longitude: coordinates.longitude)

        view.mapWindow.map.move(
            with: YMKCameraPosition(
                target: point,
                zoom: zoom,
                azimuth: 0,
                tilt: 0
            )
        )
    }

    func showPins(_ pins: [PinViewModel]) {
        let mapObjects = view.mapWindow.map.mapObjects
        mapObjects.clear()
        currentPins = []

        for pin in pins {
            let pinView = PinView(viewModel: pin)
            if let viewImage = convertViewToImage(pinView) {
                let placemark = mapObjects.addPlacemark(
                    with: YMKPoint(latitude: pin.coordinates.latitude, longitude: pin.coordinates.longitude),
                    image: viewImage
                )
                placemark.userData = pin
                placemark.addTapListener(with: self)
                currentPins.append(pinView)

                if pin.pinType == .cluster {
                    pin.placemark = placemark
                    pin.onPhotoDownloaded = { [weak self] image in
                        DispatchQueue.main.async {
                            pin.view?.photoView.image = image
                            guard let pinView = pin.view,
                                  let viewImageWithPhoto = self?.convertViewToImage(pinView),
                                  let placemark = pin.placemark as? YMKPlacemarkMapObject
                            else { return }

                            placemark.setIconWith(viewImageWithPhoto)
                        }
                    }
                }
            }
        }
    }

    private func convertViewToImage(_ view: UIView) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { ctx in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        return image
    }
}

// MARK: - YMKMapCameraListner
extension YandexMapView: YMKMapCameraListener {
    func onCameraPositionChanged(with map: YMKMap, cameraPosition: YMKCameraPosition, cameraUpdateReason: YMKCameraUpdateReason, finished: Bool) {

        guard finished,
              map === view.mapWindow.map else { return }

        let location = Coordinate(
            latitude: cameraPosition.target.latitude,
            longitude: cameraPosition.target.longitude
        )

        let ne = Coordinate(
            latitude: map.visibleRegion.topRight.latitude,
            longitude: map.visibleRegion.topRight.longitude
        )

        let sw = Coordinate(
            latitude: map.visibleRegion.bottomLeft.latitude,
            longitude: map.visibleRegion.bottomLeft.longitude
        )

        let boundingBox = BoundingBox(ne: ne, sw: sw)

        viewModel.cameraPositionChanged(with: boundingBox, location: location, zoom: cameraPosition.zoom)
    }
}

//MARK: - YMKMapObjectTapListener

extension YandexMapView: YMKMapObjectTapListener {
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        guard let placemark = mapObject as? YMKPlacemarkMapObject,
              let pinViewModel = placemark.userData as? PinViewModel
        else { return false }

        switch pinViewModel.pinType {
        case .pin:
            viewModel.showPhoto(fromPin: pinViewModel)
            print("--- You just tapped a pin with year \(pinViewModel.year) ---")
        case .cluster:
            viewModel.zoomIn(at: pinViewModel.coordinates)
        }

        return true
    }
}
