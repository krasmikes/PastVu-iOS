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

    func moveTo(coordinates: [Double])
    func moveToCurrentLocation()
    func zoomIn()
    func zoomOut()
}

protocol MapViewDelegate {
    func locationChanged(withCoordinates coordinates: CLLocationCoordinate2D, zoom: Int, boundingBox: BoundingBox)
}
