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
    func setPhoto(with url: URL)
}

class PhotoViewImpl: UIViewController {
    var viewModel: PhotoViewModel
    private let photoView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let photoScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentMode = .scaleToFill
        return scrollView
    }()
    private var photoViewTopConstraint: NSLayoutConstraint!
    private var photoViewLeadingConstraint: NSLayoutConstraint!
    private var photoViewTrailingConstraint: NSLayoutConstraint!
    private var photoViewBottomConstraint: NSLayoutConstraint!

    private let activityIndicator = UIActivityIndicatorView()

    private let infoContainerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black.withAlphaComponent(0.5)
        return view
    }()
    private let infoScrollView = UIScrollView(frame: .zero)
    private let infoTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 2
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    private let infoDescription: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.textColor = .white
        textView.font = .systemFont(ofSize: 18)
        return textView
    }()
    private let infoYear: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        return label
    }()
    private let infoAddress: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        return label
    }()
    private var infoContainerViewTopConstraint: NSLayoutConstraint!
    private var infoContainerViewInitialCenter: CGPoint = .zero
    private var infoContainerViewUpPosition: CGPoint = .zero
    private var infoContainerViewDownPosition: CGPoint = .zero

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
        photoScrollView.delegate = self
        setNavigationBarAppearence()
        setGestureRecognizers()

        photoScrollView.addSubviews(photoView)
        view.addSubviews(photoScrollView, activityIndicator, infoContainerView)
        infoContainerView.addSubviews(infoScrollView, infoTitle)
        infoScrollView.addSubviews(infoDescription, infoYear, infoAddress)

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

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            infoContainerViewTopConstraint,
            infoContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoContainerView.heightAnchor.constraint(equalTo: view.heightAnchor),

            photoViewTopConstraint,
            photoViewLeadingConstraint,
            photoViewTrailingConstraint,
            photoViewBottomConstraint,

            infoScrollView.topAnchor.constraint(equalTo: infoTitle.bottomAnchor, constant: 10),
            infoScrollView.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor),
            infoScrollView.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor),
            infoScrollView.bottomAnchor.constraint(equalTo: infoContainerView.bottomAnchor),

            infoTitle.topAnchor.constraint(equalTo: infoContainerView.topAnchor, constant: 10),
            infoTitle.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 20),
            infoTitle.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -20),

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
        activityIndicator.startAnimating()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateScrollConstraintsForSize(view.bounds.size)
        updateMinMaxZoomScaleForSize(view.bounds.size)
        infoContainerViewTopConstraint.constant = view.frame.height - view.safeAreaInsets.bottom - infoTitle.frame.height - 20
        infoContainerViewUpPosition = CGPoint(x: infoContainerView.center.x, y: view.frame.height * 0.7)
        infoContainerViewDownPosition = infoContainerView.center
    }

    private func setNavigationBarAppearence() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationBarAppearance.backgroundEffect = .none
        navigationBarAppearance.backgroundColor = .black.withAlphaComponent(0.5)
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(closeButtonTapped)
        )
    }

    private func setGestureRecognizers() {
        photoScrollView
            .addGestureRecognizer(
                UITapGestureRecognizer(
                    target: self,
                    action: #selector(toggleInfoAndNavBarPresence)
                )
            )

        infoContainerView
            .addGestureRecognizer(
                UIPanGestureRecognizer(
                    target: self,
                    action: #selector(dragContainerView)
                )
            )
    }

    @objc func closeButtonTapped() {
        navigationController?.dismiss(animated: true)
    }

    @objc func toggleInfoAndNavBarPresence() {
        navigationController?.setNavigationBarHidden(navigationController?.isNavigationBarHidden ?? true ? false : true, animated: true)
        infoContainerView.isHidden.toggle()
    }
}

// MARK: - Photo Scroll View Handling
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
            self.infoDescription.attributedText = self.viewModel.photo?.description?.htmlAttributedString(size: 18, color: .white)
            self.infoYear.text = self.viewModel.photo?.year
            self.infoAddress.text = self.viewModel.photo?.address
        }
    }

    func updatePhoto(_ image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }

            self.activityIndicator.stopAnimating()
            self.photoView.image = image
        }
    }
    
    func setPhoto(with url: URL) {
        photoView.sd_setImage(with: url)
    }
}

//MARK: - Info Container Drag Handling
extension PhotoViewImpl {
    @objc func dragContainerView(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            infoContainerViewInitialCenter = infoContainerView.center
        case .changed:
            let translation = sender.translation(in: view)
            infoContainerView.center = CGPoint(
                x: infoContainerViewInitialCenter.x,
                y: infoContainerViewInitialCenter.y + translation.y
            )
        case .ended:
            let velocity = sender.velocity(in: view)
            if velocity.y > 0 {
                UIView.animate(
                    withDuration: 0.3,
                    animations: {
                        self.infoContainerView.center = self.infoContainerViewDownPosition
                    }
                )
            } else {
                UIView.animate(
                    withDuration: 0.3,
                    animations: {
                        self.infoContainerView.center = self.infoContainerViewUpPosition
                    }
                )
            }
        case .cancelled, .failed, .possible:
            UIView.animate(
                withDuration: 0.5,
                delay: 0.0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.7,
                options: [.curveEaseInOut])
            {
                self.infoContainerView.center = self.infoContainerViewInitialCenter
            }
        @unknown default:
            return
        }
    }
}
