//
//  NetworkService.swift
//  PastVu
//
//  Created by Apanasenko Mikhail on 06.05.2022.
//

import Foundation
import UIKit

final class NetworkService {
    static let shared = NetworkService()

    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> ()) {
        guard var urlComponent = URLComponents(string: request.url) else {
            let error = NSError(
                domain: ErrorResponse.invalidEndpoint.rawValue,
                code: 404,
                userInfo: nil
            )

            return completion(.failure(error))
        }

        var queryItems: [URLQueryItem] = []

        request.queryItems.forEach {
            let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
            urlComponent.queryItems?.append(urlQueryItem)
            queryItems.append(urlQueryItem)
        }

        urlComponent.queryItems = queryItems

        guard let url = urlComponent.url else {
            let error = NSError(
                domain: ErrorResponse.invalidEndpoint.rawValue,
                code: 404,
                userInfo: nil
            )

            return completion(.failure(error))
        }

        print("URL is \(url)") // убрать потом

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers

        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                return completion(.failure(error))
            }

            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                return completion(.failure(NSError()))
            }

            guard let data = data else {
                return completion(.failure(NSError()))
            }

            do {
                try completion(.success(request.decode(data)))
            } catch let error as NSError {
                completion(.failure(error))
            }
        }
        .resume()
    }

    func loadImage(path: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
        guard let baseUrl = URL(string: "https://pastvu.com/_p/d/") else { return }
        let url = baseUrl.appendingPathComponent(path)

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                completion(.success(image))
            } else {
                completion(.failure(NSError()))
            }
        }
    }
}
