//
//  UserDefaultsManager.swift
//  PastVu
//
//  Created by Михаил Апанасенко on 28.05.22.
//

import Foundation
import CoreLocation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()

    private let storage = UserDefaults.standard

    //MARK: - Map Settings

    func getMapSettings() -> MapSettings {
        return MapSettings(
            provider: getPreferredMapProvider(),
            location: getLastLocation(),
            zoom: getLastZoom()
        )
    }

    //MARK: - Preferred Map Provider

    func getPreferredMapProvider() -> MapProvider {
        guard let provider = storage.object(forKey: StorageKeys.mapProvider.rawValue) as? MapProvider else {
            return MapProvider.Yandex
        }
        return provider
    }

    func setPreferredMapProvider(_ provider: MapProvider) {
        storage.set(provider, forKey: StorageKeys.mapProvider.rawValue)
    }

    //MARK: - Last Location

    func getLastLocation() -> CLLocationCoordinate2D {
        guard let location = storage.object(forKey: StorageKeys.lastLocation.rawValue) as? CLLocationCoordinate2D else {
            return CLLocationCoordinate2D(latitude: 55.755833, longitude: 37.617222)
        }
        return location
    }

    func setLastLocation(_ location: CLLocationCoordinate2D) {
        storage.set(location, forKey: StorageKeys.lastLocation.rawValue)
    }

    //MARK: - Last Zoom

    func getLastZoom() -> Int {
        guard let zoom = storage.object(forKey: StorageKeys.lastZoom.rawValue) as? Int else {
            return 15
        }
        return zoom
    }

    func setLastZoom(_ zoom: Int) {
        storage.set(zoom, forKey: StorageKeys.lastZoom.rawValue)
    }


    private enum StorageKeys: String {
        case mapProvider
        case lastLocation
        case lastZoom
    }

    enum MapProvider: String, Codable {
        case Yandex
    }

    struct MapSettings {
        let provider: MapProvider
        let location: CLLocationCoordinate2D
        let zoom: Int
    }
}
