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

    struct NearestPhotosParameters: Codable {
        var geo: [Double] = [55.755830, 37.617780]
        var except: Int? = nil
        var distance: Int? = nil
        var year: Int? = nil
        var year2: Int? = nil
        var type: PhotoType? = nil
        var limit: Int? = nil
        var skip: Int? = nil

        enum PhotoType: Codable {
            case photo
            case painting
        }

        func toString() -> String {
            guard let jsonData = try? JSONEncoder().encode(self),
                  let result = String(data: jsonData, encoding: .utf8) else { return "" }

            return result
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
