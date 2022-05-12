//
//  PastVuAPI.swift
//  PastVu
//
//  Created by Apanasenko Mikhail on 12.05.2022.
//

import Foundation

enum APIBaseUrl: String {
    case prod = "https://pastvu.com/api2"

    // It will be useful when QA target appear
    static func getBaseUrl() -> String {
        return self.prod.rawValue
    }
}

enum APIMethods {

    case photo(Photo)
    case comment(Comment)

    enum Photo: String {
        case giveForPage
        case giveNearestPhotos
        case getByBounds
    }

    enum Comment: String {
        case giveForObj
    }

    func getMethodString() -> String {
        switch self {
        case .photo(let photo):
            return "photo.\(photo.rawValue)"
        case .comment(let comment):
            return "comment.\(comment.rawValue)"
        }
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol DataRequest {
    associatedtype Response

    var url: String { get }
    var method: HTTPMethod { get }
    var headers: [String : String] { get }
    var queryItems: [String : String] { get }

    func decode(_ data: Data) throws -> Response
}

extension DataRequest where Response: Decodable {
    var headers: [String : String] {
        [:]
    }

    var queryItems: [String : String] {
        [:]
    }

    func decode(_ data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}

enum ErrorResponse: String {
    case invalidEndpoint
}
