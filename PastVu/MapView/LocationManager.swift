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
    private var onGettingCurrentLocation: ((CLLocation) -> ())? = nil
    private var location: CLLocation = CLLocation()

    override init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        super.init()
        locationManager.delegate = self
    }

    func getCurrentLocation(completion: @escaping (CLLocation) -> ()) {
        onGettingCurrentLocation = completion
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {
            return
        }
        location = mostRecentLocation
        onGettingCurrentLocation?(location)
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        locationManager.stopUpdatingLocation()
    }

}
