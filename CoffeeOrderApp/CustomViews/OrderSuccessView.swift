//
//  OrderSuccessView.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 20.04.2025.
//

import UIKit

final class OrderSuccessView: UIView {

    private let label: UILabel = {
        let label = UILabel()
        label.text = "\(AppString.successOrder.localized)✅"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let confettiLayer = CAEmitterLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.85)
        layer.cornerRadius = 20
        clipsToBounds = true

        addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }

    func show(in parentView: UIView) {
        parentView.addSubview(self)

        self.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(130)
        }

        self.alpha = 0
        self.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)

        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 1
            self.transform = .identity
        }) { _ in
            self.startConfetti(in: parentView)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                UIView.animate(withDuration: 0.3, animations: {
                    self.alpha = 0
                    self.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                }) { _ in
                    self.removeFromSuperview()
                    self.confettiLayer.removeFromSuperlayer()
                }
            }
        }
    }

    private func startConfetti(in view: UIView) {
        let cell = CAEmitterCell()
        cell.birthRate = 6
        cell.lifetime = 4.0
        cell.velocity = 200
        cell.velocityRange = 50
        cell.emissionLongitude = .pi
        cell.emissionRange = .pi / 4
        cell.spin = 3.5
        cell.spinRange = 1.0
        cell.scale = 0.05
        cell.scaleRange = 0.02
        cell.contents = Images.confetti?.cgImage ?? Images.circleFill?.cgImage
        cell.color = UIColor.random().cgColor

        confettiLayer.emitterPosition = CGPoint(x: view.bounds.midX, y: -10)
        confettiLayer.emitterShape = .line
        confettiLayer.emitterSize = CGSize(width: view.bounds.size.width, height: 2)
        confettiLayer.emitterCells = [cell]

        view.layer.addSublayer(confettiLayer)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.confettiLayer.birthRate = 0
        }
    }
}

// MARK: - Random Color
extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red: CGFloat.random(in: 0.3...1.0),
            green: CGFloat.random(in: 0.3...1.0),
            blue: CGFloat.random(in: 0.3...1.0),
            alpha: 1.0
        )
    }
}
