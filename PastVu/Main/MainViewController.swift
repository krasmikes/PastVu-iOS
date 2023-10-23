//
//  MainViewController.swift
//  PastVu
//
//  Created by Apanasenko Mikhail on 06.05.2022.
//

import UIKit
import EasyAnchor

class MainViewController: UIViewController {
    private let viewModel = MainViewModel()
    var mapView: MapView
    private let controlsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    private let zoomInButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 4
        return button
    }()
    private let zoomOutButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 4
        return button
    }()
    private let currentLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "location"), for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 4
        return button
    }()
    private var requestResult: ByBoundsResponse.Result? = nil

    private let rangeSlider: RangeSlider = {
        let rangeBoundaries = SliderConstants.rangeBoundaries
        let lastYearsBoundaries = UserDefaultsManager.shared.getLastYearsBoundaries()
        let slider = RangeSlider(
            minimumYear: rangeBoundaries.minimumYear,
            maximumYear: rangeBoundaries.maximumYear,
            lowerYear: lastYearsBoundaries.lowerYear,
            upperYear: lastYearsBoundaries.upperYear
        )
        return slider
    }()

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

        NotificationCenter.default.addObserver(viewModel, selector: "appMovedToBackground", name: UIApplication.willResignActiveNotification, object: nil)
        
        view.backgroundColor = .red

        zoomInButton.addTarget(viewModel, action: "zoomInButtonTapped", for: .touchUpInside)
        zoomOutButton.addTarget(viewModel, action: "zoomOutButtonTapped", for: .touchUpInside)
        currentLocationButton.addTarget(viewModel, action: "currentLocationButtonTapped", for: .touchUpInside)
        rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(_:)), for: .valueChanged)

        let sliderContainerView = UIView()
        sliderContainerView.addSubview(rangeSlider)
        view.addSubviews(mapView, controlsStackView, sliderContainerView)
        [
            zoomInButton,
            zoomOutButton,
            currentLocationButton
        ].forEach { controlsStackView.addArrangedSubview($0) }
        
        activate(
            mapView.anchor.edges,
            
            controlsStackView.anchor.centerY,
            controlsStackView.anchor.trailing.constant(-20),
            controlsStackView.anchor.width.equal.to(40),
            
            zoomInButton.anchor.size.equal.to(40),
            zoomOutButton.anchor.size.equal.to(40),
            currentLocationButton.anchor.size.equal.to(40),
            
            sliderContainerView.anchor.leading.trailing.bottom,
            sliderContainerView.anchor.top.equal.to(rangeSlider.anchor.top).constant(-20),
            
            rangeSlider.anchor.paddingHorizontally(20),
            rangeSlider.anchor.bottom.equal.to(view.safeAreaLayoutGuide.anchor.bottom).constant(-5),
            rangeSlider.anchor.height.equal.to(30)
            
        )

        viewModel.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        rangeSlider.updateSizes()
    }

    func showPhoto(fromPin pinViewModel: PinViewModel) {
        let photoView = PhotoViewImpl(fromPinViewModel: pinViewModel)
        let photoViewNC = UINavigationController(rootViewController: photoView)
        photoViewNC.modalPresentationStyle = .automatic
        navigationController?.present(photoViewNC, animated: true)
    }

    @objc func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
        viewModel.yearsBoundariesChanged(lowerYear: rangeSlider.lowerValue, upperYear: rangeSlider.upperValue)
    }
}
