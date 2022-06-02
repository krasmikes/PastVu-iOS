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
        super.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20)) // исправить
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
            photosCountLabel,
            photoView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        switch viewModel.pinType {
        case .pin:
            circleView.isHidden = false
            circleView.backgroundColor = .green //поменять
            circleView.layer.cornerRadius = 7.5

            directionPointer.isHidden = false
            makeDirectionPointer()

            photosCountLabel.isHidden = true
            photoView.isHidden = true

            [
                heightAnchor.constraint(equalToConstant: 20),
                widthAnchor.constraint(equalToConstant: 20),

                circleView.widthAnchor.constraint(equalToConstant: 14),
                circleView.heightAnchor.constraint(equalToConstant: 14),
                circleView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                circleView.centerYAnchor.constraint(equalTo: self.centerYAnchor),


            ].forEach { $0.isActive = true }

        case .cluster:
            circleView.isHidden = true
            directionPointer.isHidden = true

            if let count = viewModel.count {
                photosCountLabel.isHidden = false
                photosCountLabel.text = count
            }

            photoView.isHidden = false
            viewModel.getImage()

            [
                heightAnchor.constraint(equalToConstant: 20),
                widthAnchor.constraint(equalToConstant: 20),

                photoView.topAnchor.constraint(equalTo: self.topAnchor),
                photoView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                photoView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                photoView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

                photosCountLabel.leadingAnchor.constraint(equalTo: photoView.leadingAnchor),
                photosCountLabel.trailingAnchor.constraint(equalTo: photoView.trailingAnchor),
                photosCountLabel.bottomAnchor.constraint(equalTo: photoView.bottomAnchor),
                photosCountLabel.heightAnchor.constraint(equalToConstant: 5)
            ].forEach { $0.isActive = true }
        }
    }

    private func makeDirectionPointer() {
        directionPointer.image = UIImage(named: "blackTriangle")
        directionPointer.backgroundColor = .red

        if let direction = viewModel.direction {
            switch direction {
            case .ne:
                directionPointer.rotate(angle: 45)
            case .e:
                directionPointer.rotate(angle: 90)
            case .se:
                directionPointer.rotate(angle: 135)
            case .s:
                directionPointer.rotate(angle: 180)
            case .sw:
                directionPointer.rotate(angle: 225)
            case .w:
                directionPointer.rotate(angle: 270)
            case .nw:
                directionPointer.rotate(angle: 315)
            case .n:
                directionPointer.rotate(angle: 0)
            case .aero, .unknown:
                directionPointer.isHidden = true
            }
        }
    }

}
