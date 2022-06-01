//
//  MapView.swift
//  PastVu
//
//  Created by Apanasenko Mikhail on 16.05.2022.
//

import UIKit
import CoreLocation

protocol MapView: UIView {
    var viewModel: MapViewModel { get set }

    func moveTo(coordinates: Coordinate, zoom: Float)
    func showPins(_ pins: [PinViewModel])
}

protocol MapViewDelegate: AnyObject {
    func locationChanged(withCoordinates coordinates: Coordinate, zoom: Int, boundingBox: BoundingBox)
}
