//
//  PhotoView.swift
//  PastVu
//
//  Created by Михаил Апанасенко on 07.06.22.
//

import UIKit

protocol PhotoView: UIViewController {
    func updateInfo()
    func updatePhoto(_ image: UIImage)
}

class PhotoViewImpl: UIViewController {
    var viewModel: PhotoViewModel

    private let photoView = UIImageView(frame: .zero)
    private let photoScrollView = UIScrollView(frame: .zero)

    private let infoContainerView = UIView(frame: .zero)
    private let infoScrollView = UIScrollView(frame: .zero)
    private let infoTitle = UILabel(frame: .zero)
    private let infoDescription = UILabel(frame: .zero)
    private let infoYear = UILabel(frame: .zero)
    private let infoAddress = UILabel(frame: .zero)

    private var photoViewTopConstraint: NSLayoutConstraint!
    private var photoViewLeadingConstraint: NSLayoutConstraint!
    private var photoViewTrailingConstraint: NSLayoutConstraint!
    private var photoViewBottomConstraint: NSLayoutConstraint!
    private var infoContainerViewTopConstraint: NSLayoutConstraint!

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
        view.backgroundColor = .black

        // Navigation Bar Settings
        photoScrollView.contentInsetAdjustmentBehavior = .never
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationBarAppearance.backgroundEffect = .none
        navigationBarAppearance.backgroundColor = .black.withAlphaComponent(0.5)
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        let leftBarItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeButtonTapped))
        self.navigationItem.leftBarButtonItem = leftBarItem
        let oneTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleInfoAndNavBarPresence))
        photoScrollView.addGestureRecognizer(oneTapGestureRecognizer)

        // Info Container Settings
        infoContainerView.backgroundColor = .black.withAlphaComponent(0.5)

        infoTitle.numberOfLines = 2
        infoTitle.textColor = .white

        infoDescription.numberOfLines = 0
        infoDescription.textColor = .white

        infoYear.textColor = .white

        infoAddress.textColor = .white

        // Photo Scroll View Settings
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.contentMode = .scaleAspectFit
        photoScrollView.addSubview(photoView)
        photoScrollView.delegate = self
        photoScrollView.contentMode = .scaleToFill

        // Views Arrangement
        [
            photoScrollView,
            infoContainerView,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        infoScrollView.translatesAutoresizingMaskIntoConstraints = false
        infoContainerView.addSubview(infoScrollView)

        [
            infoTitle,
            infoDescription,
            infoYear,
            infoAddress
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            infoScrollView.addSubview($0)
        }

        // Constraints
        photoViewTopConstraint = photoView.topAnchor.constraint(equalTo: photoScrollView.topAnchor)
        photoViewLeadingConstraint = photoView.leadingAnchor.constraint(equalTo: photoScrollView.leadingAnchor)
        photoViewTrailingConstraint = photoScrollView.trailingAnchor.constraint(equalTo: photoView.trailingAnchor)
        photoViewBottomConstraint = photoScrollView.bottomAnchor.constraint(equalTo: photoView.bottomAnchor)

        infoContainerViewTopConstraint = infoContainerView.topAnchor.constraint(equalTo: view.topAnchor)

        [
            photoScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            photoScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            infoContainerViewTopConstraint,
            infoContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoContainerView.heightAnchor.constraint(equalTo: view.heightAnchor),

            photoViewTopConstraint,
            photoViewLeadingConstraint,
            photoViewTrailingConstraint,
            photoViewBottomConstraint,

            infoScrollView.topAnchor.constraint(equalTo: infoContainerView.topAnchor),
            infoScrollView.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor),
            infoScrollView.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor),
            infoScrollView.bottomAnchor.constraint(equalTo: infoContainerView.bottomAnchor),

            infoTitle.topAnchor.constraint(equalTo: infoScrollView.topAnchor, constant: 10),
            infoTitle.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 10),
            infoTitle.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -10),

            infoDescription.topAnchor.constraint(equalTo: infoTitle.bottomAnchor, constant: 10),
            infoDescription.leadingAnchor.constraint(equalTo: infoTitle.leadingAnchor),
            infoDescription.trailingAnchor.constraint(equalTo: infoTitle.trailingAnchor),

            infoYear.topAnchor.constraint(equalTo: infoDescription.bottomAnchor, constant: 10),
            infoYear.leadingAnchor.constraint(equalTo: infoDescription.leadingAnchor),
            infoYear.trailingAnchor.constraint(equalTo: infoDescription.trailingAnchor),

            infoAddress.topAnchor.constraint(equalTo: infoYear.bottomAnchor, constant: 10),
            infoAddress.leadingAnchor.constraint(equalTo: infoYear.leadingAnchor),
            infoAddress.trailingAnchor.constraint(equalTo: infoYear.trailingAnchor),
        ].forEach { $0.isActive = true }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateScrollConstraintsForSize(view.bounds.size)
        updateMinMaxZoomScaleForSize(view.bounds.size)
        infoContainerViewTopConstraint.constant = view.bounds.size.height * 0.75
    }

    @objc func closeButtonTapped() {
        navigationController?.dismiss(animated: true)
    }

    @objc func toggleInfoAndNavBarPresence() {
        navigationController?.setNavigationBarHidden(navigationController?.isNavigationBarHidden ?? true ? false : true, animated: true)
        infoContainerView.isHidden.toggle()
    }
}

// MARK: - Photo Scroll View Handeling
extension PhotoViewImpl: UIScrollViewDelegate {
    func updateMinMaxZoomScaleForSize(_ size: CGSize) {
        guard photoView.bounds.width != 0,
              photoView.bounds.height != 0 else { return }

        let minScale = min(
            size.width / photoView.bounds.width,
            size.height / photoView.bounds.height)
        let maxScale = max(
            (size.width + 1.0) / photoView.bounds.width,
            (size.height + 1.0) / photoView.bounds.height)

        photoScrollView.minimumZoomScale = minScale
        photoScrollView.zoomScale = minScale
        photoScrollView.maximumZoomScale = maxScale * 2
    }

    func updateScrollConstraintsForSize(_ size: CGSize) {
        let yOffset = max(0, (size.height - photoView.frame.height) / 2)
        photoViewTopConstraint.constant = yOffset
        photoViewBottomConstraint.constant = yOffset

        let xOffset = max(0, (size.width - photoView.frame.width) / 2)
        photoViewLeadingConstraint.constant = xOffset
        photoViewTrailingConstraint.constant = xOffset
        view.layoutIfNeeded()
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateScrollConstraintsForSize(view.bounds.size)
    }
}

extension PhotoViewImpl: PhotoView {
    func updateInfo() {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }

            self.infoTitle.text = self.viewModel.photo?.title
            self.infoDescription.text = self.viewModel.photo?.description
            self.infoYear.text = self.viewModel.photo?.year
            self.infoAddress.text = self.viewModel.photo?.address
        }
    }

    func updatePhoto(_ image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }

            self.photoView.image = image
        }
    }


}
