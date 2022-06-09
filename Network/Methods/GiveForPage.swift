//
//  GiveForPage.swift
//  PastVu
//
//  Created by Михаил Апанасенко on 07.06.22.
//

import Foundation

struct GiveForPage: DataRequest {
    typealias Response = GiveForPageResponse

    private let apiMethod: String = APIMethods.photo(.giveForPage).getMethodString()

    var url: String = APIBaseUrl.getBaseUrl()

    var params: GiveForPageParameters

    var queryItems: [String : String] {
        [
            "method": apiMethod,
            "params": params.toString()
        ]
    }

    var method: HTTPMethod {
        .get
    }

    func decode(_ data: Data) throws -> GiveForPageResponse {
        let decoder = JSONDecoder()
        let response = try decoder.decode(GiveForPageResponse.self, from: data)
        return response
    }

    struct GiveForPageParameters: RequestParameters {
        var id: Int

        enum CodingKeys: String, CodingKey {
            case id = "cid"
        }
    }
}

struct GiveForPageResponse: Codable {
    let result: Result
    let rid: String

    struct Result: Codable {
        let photo: Photo
    }
}
