//
//  ViewController.swift
//  PastVu
//
//  Created by Apanasenko Mikhail on 06.05.2022.
//

import UIKit

class ViewController: UIViewController {
    let networkService = NetworkServiceImpl()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red

        let parameters = NearestPhotosRequest.NearestPhotosParameters(
            geo: [41.693360, 44.801222]
        )

        let request = NearestPhotosRequest(params: parameters)

        print(request)

        networkService.request(request) { result in
            switch result {
            case .success(let response):
                print(response.result)
            case .failure(let error):
                print(error)
            }
        }

    }


}

