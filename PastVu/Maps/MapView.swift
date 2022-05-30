//
//  MapView.swift
//  PastVu
//
//  Created by Apanasenko Mikhail on 16.05.2022.
//

import UIKit
import CoreLocation

protocol MapView: UIView {
    var delegate: MapViewDelegate? { get set }
    var location: Coordinate { get set }
    var currentZoom: Float { get set }

    func moveTo(coordinates: Coordinate)
    func moveToCurrentLocation()
    func zoomIn()
    func zoomOut()
}

protocol MapViewDelegate {
    func locationChanged(withCoordinates coordinates: Coordinate, zoom: Int, boundingBox: BoundingBox)
}
