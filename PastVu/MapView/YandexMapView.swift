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
    var delegate: MapViewDelegate?

    private let locationManager = LocationManager.shared
    private var location: CLLocation = CLLocation()
    private var currentZoom: Float = 15

    private let view = YMKMapView(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        view.mapWindow.map.addCameraListener(with: self)

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

    func moveTo(coordinates: [Double]) {
        location = CLLocation(latitude: coordinates[0], longitude: coordinates[1])

        let point = YMKPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

        view.mapWindow.map.move(
            with: YMKCameraPosition.init(target: point, zoom: currentZoom, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
            cameraCallback: nil)
    }

    func moveToCurrentLocation() {
        locationManager.getCurrentLocation { [weak self] location in
            guard let `self` = self else { return }

            self.location = location

            let point = YMKPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

            self.view.mapWindow.map.move(
                with: YMKCameraPosition.init(target: point, zoom: self.currentZoom, azimuth: 0, tilt: 0)
            )

        }
    }

    func zoomIn() {
        currentZoom += 1
        let point = YMKPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

        view.mapWindow.map.move(
            with: YMKCameraPosition.init(target: point, zoom: currentZoom, azimuth: 0, tilt: 0)
        )
    }

    func zoomOut() {
        currentZoom -= 1
        let point = YMKPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

        view.mapWindow.map.move(
            with: YMKCameraPosition.init(target: point, zoom: currentZoom, azimuth: 0, tilt: 0)
        )
    }
}

extension YandexMapView: YMKMapCameraListener {
    func onCameraPositionChanged(with map: YMKMap, cameraPosition: YMKCameraPosition, cameraUpdateReason: YMKCameraUpdateReason, finished: Bool) {

        guard finished,
              map === view.mapWindow.map else { return }

        location = CLLocation(latitude: cameraPosition.target.latitude, longitude: cameraPosition.target.longitude)
        currentZoom = cameraPosition.zoom

        delegate?.locationChanged(withCoordinates: location)
    }
}


