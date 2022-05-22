//
//  NearestPhotos.swift
//  PastVu
//
//  Created by Apanasenko Mikhail on 11.05.2022.
//

import Foundation

struct NearestPhotosRequest: DataRequest {
    typealias Response = NearestPhotosResponse

    private let apiMethod: String = APIMethods.photo(.giveNearestPhotos).getMethodString()

    var url: String = APIBaseUrl.getBaseUrl()

    var params: NearestPhotosParameters

    var queryItems: [String : String] {
        [
            "method": apiMethod,
            "params": params.toString()
        ]
    }

    var method: HTTPMethod {
        .get
    }

    func decode(_ data: Data) throws -> NearestPhotosResponse {
        let decoder = JSONDecoder()
        let response = try decoder.decode(NearestPhotosResponse.self, from: data)
        return response
    }

    struct NearestPhotosParameters: RequestParameters {
        var coordinates: [Double] //поменять на тип координат
        var except: Int? = nil
        var distance: Int? = nil
        var yearFrom: Int? = nil
        var yearTo: Int? = nil
        var type: PhotoType? = nil
        var limit: Int? = nil
        var skip: Int? = nil

        enum PhotoType: Codable {
            case photo
            case painting
        }

        enum CodingKeys: String, CodingKey {
            case coordinates = "geo"
            case yearFrom = "year"
            case yearTo = "year2"
            case except, distance, type, limit, skip
        }
    }
}

struct NearestPhotosResponse: Codable {
    let result: Result
    let rid: String

    struct Result: Codable {
        let photos: [Photo]
    }
}
