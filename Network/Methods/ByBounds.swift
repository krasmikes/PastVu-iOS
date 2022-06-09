//
//  ByBounds.swift
//  PastVu
//
//  Created by Apanasenko Mikhail on 19.05.2022.
//

import Foundation

struct ByBoundsRequest: DataRequest {
    typealias Response = ByBoundsResponse

    private let apiMethod: String = APIMethods.photo(.getByBounds).getMethodString()

    var url: String = APIBaseUrl.getBaseUrl()

    var params: ByBoundsParameters

    var queryItems: [String : String] {
        [
            "method": apiMethod,
            "params": params.toString()
        ]
    }

    var method: HTTPMethod {
        .get
    }

    func decode(_ data: Data) throws -> ByBoundsResponse {
        let decoder = JSONDecoder()
        let response = try decoder.decode(ByBoundsResponse.self, from: data)
        return response
    }

    struct ByBoundsParameters: RequestParameters {
        var polygon: Polygon
        var zoom: Int
        var isPainting: Bool? = nil
        var yearFrom: Int? = nil
        var yearTo: Int? = nil
        var localWork: Bool? = nil

        enum CodingKeys: String, CodingKey {
            case polygon = "geometry"
            case zoom = "z"
            case yearFrom = "year"
            case yearTo = "year2"
            case isPainting, localWork
        }
    }
}

struct ByBoundsResponse: Codable {
    let result: Result
    let rid: String

    struct Result: Codable {
        let zoom: Int
        let photos: [Pin]
        let clusters: [Cluster]

        enum CodingKeys: String, CodingKey {
            case zoom = "z"
            case photos, clusters
        }
    }
}
