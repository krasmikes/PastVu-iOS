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

        for pin in pins {
            let pinView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
            pinView.backgroundColor = pin.pinType == .pin ? .green : .red
            pinView.layer.cornerRadius = 5

            let viewProvider = YRTViewProvider(uiView: pinView)

            if let viewProvider = viewProvider {
                mapObjects.addPlacemark(
                    with: YMKPoint(latitude: pin.coordinates.latitude, longitude: pin.coordinates.longitude),
                    view: viewProvider
                )
            }
        }
    }

    
}

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


