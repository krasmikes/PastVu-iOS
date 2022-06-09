//
//  PhotoViewModel.swift
//  PastVu
//
//  Created by Михаил Апанасенко on 07.06.22.
//

import Foundation

class PhotoViewModel {
    weak var view: PhotoView?
    private let networkService = NetworkService.shared

    var photo: Photo? {
        didSet {
            updateViewTextFields()
            loadPhotoImage()
        }
    }

    func getData(id: Int) {
        let request = GiveForPage(
            params: GiveForPage.GiveForPageParameters(id: id)
        )
        networkService.request(
            request) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.photo = response.result.photo
                case .failure(let error):
                    print("--- ERROR OCCURED: \(error) ---")
                }
            }
    }

    private func updateViewTextFields() {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.view?.photoTitle.text = self.photo?.title
            self.view?.photoDescription.text = self.photo?.description
            self.view?.year.text = self.photo?.year
            self.view?.address.text = self.photo?.address
        }
    }

    private func loadPhotoImage () {
        guard let photoUrl = photo?.filePath else { return }
        networkService.loadImage(
            path: photoUrl) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async { [weak self] in
                        self?.view?.photoView.image = image
                    }
                case .failure(let error):
                    print("--- ERROR OCCURED WITH IMAGE: \(error) ---")
                }
            }
    }
}
