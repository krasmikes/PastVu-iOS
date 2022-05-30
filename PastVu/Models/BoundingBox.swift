//
//  BoundingBox.swift
//  PastVu
//
//  Created by Apanasenko Mikhail on 19.05.2022.
//
// n, s - latitude - top/down; w, e - longitude - left/right

import Foundation
import CoreLocation

struct BoundingBox {
    let ne: Coordinate
    let sw: Coordinate
    var topLeft: [Double] {
        [ne.latitude, sw.longitude]
    }
    var topRight: [Double] {
        [ne.latitude, ne.longitude]
    }
    var bottomLeft: [Double] {
        [sw.latitude, sw.longitude]
    }
    var bottomRight: [Double] {
        [sw.latitude, ne.longitude]
    }

    func getPolygon(startFrom: BoundingBoxDirection, isCoordinatesReversed: Bool) -> Polygon {
        var corners = isCoordinatesReversed ? [
            topLeft.reversed(),
            topRight.reversed(),
            bottomRight.reversed(),
            bottomLeft.reversed()
        ] : [
            topLeft,
            topRight,
            bottomRight,
            bottomLeft
        ]
        var coordinates = [[Double]]()
        var index = startFrom.rawValue

        if index >= 4 {
            corners.reverse()
            index -= 4
        }

        for i in index..<4 {
            coordinates.append(corners[i])
        }

        if coordinates.count != 4 {
            for i in 0..<index {
                coordinates.append(corners[i])
            }
        }

        coordinates.append(corners[index])

        let polygon = Polygon(
            type: .polygon,
            coordinates: [coordinates]
        )
        return polygon

    }

    enum BoundingBoxDirection: Int {
        case topLeftClockWise = 0
        case topRightClockWise = 1
        case bottomRightClockWise = 2
        case bottomLeftClockWise = 3

        case bottomLeftCounterClockWise = 4
        case bottomRightCounterClockWise = 5
        case topRightCounterClockWise = 6
        case topLeftCounterClockWise = 7
    }
}

