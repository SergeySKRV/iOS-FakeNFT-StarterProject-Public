//
//  GradientView.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 14.09.2025.
//

import UIKit

// MARK: - Gradient View
final class GradientView: UIView {
    // MARK: - Static Constants
    override static var layerClass: AnyClass {
        CAGradientLayer.self
    }

    // MARK: - UI Properties
    private var gradientLayer: CAGradientLayer!

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }

    // MARK: - Private Methods
    private func setupGradient() {
        gradientLayer = layer as? CAGradientLayer

        gradientLayer.colors = [
            UIColor.yaBlackUniversal.withAlphaComponent(0.0).cgColor,
            UIColor.yaBlackUniversal.withAlphaComponent(0.2).cgColor,
            UIColor.yaBlackUniversal.withAlphaComponent(0.6).cgColor
        ]

        gradientLayer.locations = [0.0, 0.4, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint.zero
    }
}
