//
//  SlideView.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 14.09.2025.
//

import UIKit

// MARK: - Custom Slide View
final class SlideView: UIView {
    // MARK: - UI Elements
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let gradientView: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.sfProBold32
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.sfProRegular15
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Private Methods
    private func setupView() {
        addSubview(imageView)
        addSubview(gradientView)
        addSubview(contentStackView)

        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(subtitleLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            gradientView.topAnchor.constraint(equalTo: topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 240),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }

    // MARK: - Public Methods
    func configure(with slide: OnboardingSlide) {
        imageView.image = slide.image
        titleLabel.text = slide.title
        subtitleLabel.text = slide.subtitle
    }
}
