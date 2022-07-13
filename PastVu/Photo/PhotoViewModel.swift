//
//  PhotoViewModel.swift
//  PastVu
//
//  Created by Михаил Апанасенко on 07.06.22.
//

import Foundation
import UIKit

class PhotoViewModel {
    weak var view: PhotoView?
    private let networkService = NetworkService.shared

    var photo: Photo? {
        didSet {
            updateViewTextFields()
            loadPhotoImage()
        }
    }

    var photoImage: UIImage?

    func getData(id: Int) {
        let request = GiveForPage(
            params: GiveForPage.GiveForPageParameters(id: id)
        )
        networkService.request(
            request) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.photo = response.result.photo
                case .failure(_):
                    print("--- ERROR OCCURED IN PHOTOVIEWMODEL GETDATA ---")
                }
            }
    }

    private func updateViewTextFields() {
        view?.updateInfo()
    }

    private func loadPhotoImage () {
        guard let photoUrl = photo?.filePath else { return }
        networkService.loadImage(
            path: photoUrl) { [weak self] result in
                switch result {
                case .success(let image):
                    self?.view?.updatePhoto(image)
                    self?.photoImage = image
                case .failure(_):
                    print("--- ERROR OCCURED IN PHOTOVIEWMODEL LOADPHOTOIMAGE ---")
                }
            }
    }
}
