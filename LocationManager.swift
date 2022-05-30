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
    private var onGettingCurrentLocation: ((Coordinate) -> ())?
    private var location: Coordinate?

    override init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        super.init()
        locationManager.delegate = self
    }

    func getCurrentLocation(completion: @escaping (Coordinate) -> ()) {
        onGettingCurrentLocation = completion
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentCoordinates = locations.last?.coordinate else {
            return
        }
        let location = Coordinate(
            latitude: mostRecentCoordinates.latitude,
            longitude: mostRecentCoordinates.longitude
        )
        
        self.location = location
        onGettingCurrentLocation?(location)
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error) // обработать ошибку
        locationManager.stopUpdatingLocation()
    }

}
