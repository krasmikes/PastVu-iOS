//
//  PhotoView.swift
//  PastVu
//
//  Created by Михаил Апанасенко on 07.06.22.
//

import UIKit

class PhotoView: UIViewController {
    var viewModel: PhotoViewModel

    let photoView = UIImageView(frame: .zero)
    let photoTitle = UILabel(frame: .zero)
    let photoDescription = UILabel(frame: .zero)
    let year = UILabel(frame: .zero)
    let address = UILabel(frame: .zero)

    init(fromPinViewModel pinViewModel: PinViewModel) {
        viewModel = PhotoViewModel()
        super.init(nibName: nil, bundle: nil)
        viewModel.view = self
        viewModel.getData(id: pinViewModel.id)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // исправить
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = .gray

        [
            photoView,
            photoTitle,
            photoDescription,
            year,
            address
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        [
            photoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            photoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            photoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            photoView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),

            photoTitle.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 10),
            photoTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            photoTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),

            photoDescription.topAnchor.constraint(equalTo: photoTitle.bottomAnchor, constant: 10),
            photoDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            photoDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),

            year.topAnchor.constraint(equalTo: photoDescription.bottomAnchor, constant: 10),
            year.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            year.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),

            address.topAnchor.constraint(equalTo: year.bottomAnchor, constant: 10),
            address.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            address.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
        ].forEach { $0.isActive = true }
    }
}
