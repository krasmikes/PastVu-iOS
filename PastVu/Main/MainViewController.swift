//
//  MainViewController.swift
//  PastVu
//
//  Created by Apanasenko Mikhail on 06.05.2022.
//

import UIKit
import CoreLocation
import YandexMapsMobile

class MainViewController: UIViewController {
    private let viewModel = MainViewModel()
    var mapView: MapView
    private let controlsStackView = UIStackView(frame: .zero)
    private let zoomInButton = UIButton(frame: .zero)
    private let zoomOutButton = UIButton(frame: .zero)
    private let currentLocationButton = UIButton(frame: .zero)
    private var requestResult: ByBoundsResponse.Result? = nil

    init() {
        switch viewModel.provider {
        case .Yandex:
            let mapViewModel = MapViewModel(
                provider: viewModel.provider,
                location: viewModel.location,
                zoom: Float(viewModel.zoom)
            )
            mapView = YandexMapView(viewModel: mapViewModel)
        }
        mapView.viewModel.delegate = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // починить
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        
        view.backgroundColor = .red

        controlsStackView.axis = .vertical
        controlsStackView.spacing = 10

        zoomInButton.setImage(UIImage(systemName: "plus"), for: .normal)
        zoomInButton.backgroundColor = .lightGray
        zoomInButton.layer.cornerRadius = 4
        zoomInButton.addTarget(viewModel, action: "zoomInButtonTapped", for: .touchUpInside)

        zoomOutButton.setImage(UIImage(systemName: "minus"), for: .normal)
        zoomOutButton.backgroundColor = .lightGray
        zoomOutButton.layer.cornerRadius = 4
        zoomOutButton.addTarget(viewModel, action: "zoomOutButtonTapped", for: .touchUpInside)

        currentLocationButton.setImage(UIImage(systemName: "location"), for: .normal)
        currentLocationButton.backgroundColor = .lightGray
        currentLocationButton.layer.cornerRadius = 4
        currentLocationButton.addTarget(viewModel, action: "currentLocationButtonTapped", for: .touchUpInside)

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

        viewModel.viewDidLoad()
    }

    func showPhoto(fromPin pinViewModel: PinViewModel) {
        let photoView = PhotoView(fromPinViewModel: pinViewModel)
        let photoViewNC = UINavigationController(rootViewController: photoView)
        photoViewNC.modalPresentationStyle = .automatic
        navigationController?.present(photoViewNC, animated: true)
    }
}
