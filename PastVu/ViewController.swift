//
//  ViewController.swift
//  PastVu
//
//  Created by Apanasenko Mikhail on 06.05.2022.
//

import UIKit
import CoreLocation
import YandexMapsMobile

class ViewController: UIViewController {
    private let networkService = NetworkServiceImpl()
    private var mapView: MapView = YandexMapView(frame: .zero)
    private let controlsStackView = UIStackView(frame: .zero)
    private let zoomInButton = UIButton(frame: .zero)
    private let zoomOutButton = UIButton(frame: .zero)
    private let currentLocationButton = UIButton(frame: .zero)


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red

        mapView.delegate = self

        controlsStackView.axis = .vertical
        controlsStackView.spacing = 10

        zoomInButton.setImage(UIImage(systemName: "plus"), for: .normal)
        zoomInButton.backgroundColor = .lightGray
        zoomInButton.layer.cornerRadius = 4
        zoomInButton.addTarget(self, action: #selector(zoomInButtonTapped), for: .touchUpInside)

        zoomOutButton.setImage(UIImage(systemName: "minus"), for: .normal)
        zoomOutButton.backgroundColor = .lightGray
        zoomOutButton.layer.cornerRadius = 4
        zoomOutButton.addTarget(self, action: #selector(zoomOutButtonTapped), for: .touchUpInside)

        currentLocationButton.setImage(UIImage(systemName: "location"), for: .normal)
        currentLocationButton.backgroundColor = .lightGray
        currentLocationButton.layer.cornerRadius = 4
        currentLocationButton.addTarget(self, action: #selector(currentLocationButtonTapped), for: .touchUpInside)

        [
            mapView,
            controlsStackView,
            zoomInButton,
            zoomOutButton,
            currentLocationButton
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        [
            mapView,
            controlsStackView
        ].forEach { view.addSubview($0) }

        [
            zoomInButton,
            zoomOutButton,
            currentLocationButton
        ].forEach { controlsStackView.addArrangedSubview($0) }

        [
            mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mapView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0),

            controlsStackView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor),
            controlsStackView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
            controlsStackView.widthAnchor.constraint(equalToConstant: 40),

            zoomInButton.heightAnchor.constraint(equalToConstant: 40),

            zoomOutButton.heightAnchor.constraint(equalToConstant: 40),

            currentLocationButton.heightAnchor.constraint(equalToConstant: 40),

        ].forEach { $0.isActive = true }

        mapView.moveTo(coordinates: [55.751574, 37.573856])
        

//        let parameters = NearestPhotosRequest.NearestPhotosParameters(
//            geo: [41.693360, 44.801222]
//        )
//
//        let request = NearestPhotosRequest(params: parameters)
//
//        print(request)
//
//        networkService.request(request) { result in
//            switch result {
//            case .success(let response):
//                print(response.result)
//            case .failure(let error):
//                print(error)
//            }
//        }

    }

    @objc func currentLocationButtonTapped() {
        mapView.moveToCurrentLocation()
    }

    @objc func zoomInButtonTapped() {
        mapView.zoomIn()
    }

    @objc func zoomOutButtonTapped() {
        mapView.zoomOut()
    }
}

extension ViewController: MapViewDelegate {
    func locationChanged(withCoordinates coordinates: CLLocation) {
        print("--- map view delegate method location changed called with coordinates: \(coordinates)")
    }
}
