//
//  LocationManager.swift
//  PastVu
//
//  Created by Apanasenko Mikhail on 17.05.2022.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()

    private let locationManager : CLLocationManager
    private var onGettingCurrentLocation: ((CLLocationCoordinate2D) -> ())?
    private var location: CLLocationCoordinate2D?

    override init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        super.init()
        locationManager.delegate = self
    }

    func getCurrentLocation(completion: @escaping (CLLocationCoordinate2D) -> ()) {
        onGettingCurrentLocation = completion
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {
            return
        }
        location = mostRecentLocation.coordinate
        onGettingCurrentLocation?(mostRecentLocation.coordinate)
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error) // обработать ошибку
        locationManager.stopUpdatingLocation()
    }

}
