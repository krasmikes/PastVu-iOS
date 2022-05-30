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

    func setMapSettings(_ settings: MapSettings) {
        setPreferredMapProvider(settings.provider)
        setLastLocation(settings.location)
        setLastZoom(settings.zoom)
    }

    //MARK: - Preferred Map Provider

    func getPreferredMapProvider() -> MapProvider {
        guard let providerData = storage.data(forKey: StorageKeys.mapProvider.rawValue),
              let provider = try? JSONDecoder().decode(MapProvider.self, from: providerData) else {
            return MapProvider.Yandex
        }
        return provider
    }

    func setPreferredMapProvider(_ provider: MapProvider) {
        guard let providerData = try? JSONEncoder().encode(provider) else {
            return
        }
        storage.set(providerData, forKey: StorageKeys.mapProvider.rawValue)
    }

    //MARK: - Last Location

    func getLastLocation() -> Coordinate {
        guard let locationData = storage.data(forKey: StorageKeys.lastLocation.rawValue),
              let location = try? JSONDecoder().decode(Coordinate.self, from: locationData) else {
            return Coordinate(latitude: 55.755833, longitude: 37.617222)
        }
        return location
    }

    func setLastLocation(_ location: Coordinate) {
        guard let locationData = try? JSONEncoder().encode(location) else {
            return
        }
        storage.set(locationData, forKey: StorageKeys.lastLocation.rawValue)
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
}
