//
//  FullscreenPhotoViewController.swift
//  PastVu
//
//  Created by Михаил Апанасенко on 12.06.22.
//

import UIKit

class FullscreenPhotoViewController: UIViewController {

    private let scrollView = UIScrollView(frame: .zero)
    let imageView = UIImageView(frame: .zero)

    var top: NSLayoutConstraint!
    var leading: NSLayoutConstraint!
    var trailing: NSLayoutConstraint!
    var bottom: NSLayoutConstraint!

    var maxZoomScale: CGFloat = 1.0
    var isStatusBarHidden = false

    init(with image: UIImage) {
        imageView.image = image
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented") //исправить
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = .gray

        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationBarAppearance.backgroundEffect = .none
        navigationBarAppearance.backgroundColor = .gray
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        let leftBarItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeButtonTapped))
        self.navigationItem.leftBarButtonItem = leftBarItem

        let oneTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showHideNavigationBar))
        view.addGestureRecognizer(oneTapGestureRecognizer)

        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.delegate = self
        scrollView.contentMode = .scaleToFill

        imageView.contentMode = .scaleAspectFit

        [
            scrollView,
            imageView
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        top = imageView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        leading = imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
        trailing = scrollView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
        bottom = scrollView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)

        [
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            top,
            leading,
            trailing,
            bottom

        ].forEach { $0.isActive = true }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateConstraintsForSize(view.bounds.size)
        updateMinMaxZoomScaleForSize(view.bounds.size)
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }

    @objc func closeButtonTapped() {
        navigationController?.dismiss(animated: true)
    }

    @objc func showHideNavigationBar() {
        isStatusBarHidden.toggle()
        setNeedsStatusBarAppearanceUpdate()
        navigationController?.setNavigationBarHidden(navigationController?.isNavigationBarHidden ?? true ? false : true, animated: true)

    }
}

extension FullscreenPhotoViewController {
    func updateMinMaxZoomScaleForSize(_ size: CGSize) {
        if imageView.bounds.width == 0 || imageView.bounds.height == 0 {
            return
        }

        let minScale = min(
            size.width/imageView.bounds.width,
            size.height/imageView.bounds.height)
        let maxScale = max(
            (size.width + 1.0) / imageView.bounds.width,
            (size.height + 1.0) / imageView.bounds.height)

        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
        maxZoomScale = maxScale
        scrollView.maximumZoomScale = maxZoomScale * 1.1
    }

    func updateConstraintsForSize(_ size: CGSize) {
        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        top.constant = yOffset
        bottom.constant = yOffset

        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        leading.constant = xOffset
        trailing.constant = xOffset
        view.layoutIfNeeded()
    }
}

extension FullscreenPhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(view.bounds.size)
    }
}
