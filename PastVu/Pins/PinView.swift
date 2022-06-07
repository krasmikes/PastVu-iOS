//
//  PinView.swift
//  PastVu
//
//  Created by Apanasenko Mikhail on 18.05.2022.
//

import UIKit

class PinView: UIView {
    let viewModel: PinViewModel

    let circleView = UIView(frame: .zero)
    let directionPointer = UIImageView(frame: .zero)
    let photosCountLabel = UILabel(frame: .zero)
    let photoView = UIImageView(frame: .zero)

    init(viewModel: PinViewModel) {
        self.viewModel = viewModel
        switch viewModel.pinType {
        case .pin:
            super.init(frame: CGRect(x: 0, y: 0, width: 14, height: 14))
        case .cluster:
            super.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        }

        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // исправить
    }

    private func commonInit() {
        viewModel.view = self
        backgroundColor = .clear
        [
            circleView,
            directionPointer,
            photoView,
            photosCountLabel,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        switch viewModel.pinType {
        case .pin:
            circleView.isHidden = false
            circleView.backgroundColor = .green //поменять
            circleView.layer.cornerRadius = 7

            directionPointer.isHidden = false
            makeDirectionPointer()

            photosCountLabel.isHidden = true
            photoView.isHidden = true

            [
                widthAnchor.constraint(equalToConstant: 14),
                heightAnchor.constraint(equalToConstant: 14),

                circleView.widthAnchor.constraint(equalToConstant: 14),
                circleView.heightAnchor.constraint(equalToConstant: 14),
                circleView.centerXAnchor.constraint(equalTo: centerXAnchor),
                circleView.centerYAnchor.constraint(equalTo: centerYAnchor),

                directionPointer.widthAnchor.constraint(equalToConstant: 14),
                directionPointer.heightAnchor.constraint(equalToConstant: 14),
                directionPointer.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
                directionPointer.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),

            ].forEach { $0.isActive = true }

        case .cluster:
            circleView.isHidden = true
            directionPointer.isHidden = true

            if let count = viewModel.count {
                photosCountLabel.isHidden = false
                photosCountLabel.text = count
                photosCountLabel.font = photosCountLabel.font.withSize(10)
                photosCountLabel.textColor = .white
                photosCountLabel.textAlignment = .center
            }

            photoView.isHidden = false
            photoView.backgroundColor = .gray
            photoView.image = UIImage(systemName: "photo")
            viewModel.getImage()

            [
                heightAnchor.constraint(equalToConstant: 40),
                widthAnchor.constraint(equalToConstant: 40),

                photoView.topAnchor.constraint(equalTo: self.topAnchor),
                photoView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                photoView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                photoView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

                photosCountLabel.leadingAnchor.constraint(equalTo: photoView.leadingAnchor),
                photosCountLabel.trailingAnchor.constraint(equalTo: photoView.trailingAnchor),
                photosCountLabel.bottomAnchor.constraint(equalTo: photoView.bottomAnchor),
                photosCountLabel.heightAnchor.constraint(equalToConstant: 10)
            ].forEach { $0.isActive = true }
        }
    }

    private func makeDirectionPointer() {
        if let direction = viewModel.direction {
            switch direction {
            case .ne:
                directionPointer.image = UIImage(named: "northEastArrow")
            case .e:
                directionPointer.image = UIImage(named: "eastArrow")
            case .se:
                directionPointer.image = UIImage(named: "southEastArrow")
            case .s:
                directionPointer.image = UIImage(named: "southArrow")
            case .sw:
                directionPointer.image = UIImage(named: "southWestArrow")
            case .w:
                directionPointer.image = UIImage(named: "westArrow")
            case .nw:
                directionPointer.image = UIImage(named: "northWestArrow")
            case .n:
                directionPointer.image = UIImage(named: "northArrow")
            case .aero, .unknown:
                directionPointer.isHidden = true
            }
        }
    }

}
