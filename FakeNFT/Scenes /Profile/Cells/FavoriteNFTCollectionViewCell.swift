//
//  FavoriteNFTCollectionViewCell.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 16.09.2025.
//

import Kingfisher
import UIKit

// MARK: - FavoriteNFTCollectionViewCell
final class FavoriteNFTCollectionViewCell: UICollectionViewCell, ReuseIdentifying {

    // MARK: - UI Elements
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .yaSecondary
        imageView.kf.indicatorType = .activity
        return imageView
    }()

    private lazy var heartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        let heartImage = UIImage(resource: .heartfavorites).withRenderingMode(.alwaysTemplate)
        button.setImage(heartImage, for: .normal)
        button.isSelected = true
        button.tintColor = .yaWhiteUniversal
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.sfProBold17
        label.textColor = .yaPrimary
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.setContentHuggingPriority(.required, for: .horizontal)
        makeStarImageViews(in: stackView)
        return stackView
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.sfProRegular15
        label.textColor = .yaPrimary
        return label
    }()

    // MARK: - Properties
    private var onHeartButtonTapped: ((Bool) -> Void)?
    private var currentNFTId: String?

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nftImageView.image = nil
        nameLabel.text = nil
        priceLabel.text = nil
        heartButton.isSelected = false
        heartButton.tintColor = .yaWhiteUniversal
        setupRatingStars(rating: 0)
    }

    // MARK: - Public Methods
    func configure(with nft: NFTItem, onHeartTap: @escaping (Bool) -> Void) {
        self.onHeartButtonTapped = onHeartTap
        self.currentNFTId = nft.id

        nftImageView.kf.setImage(with: nft.imageUrl)

        if let firstWord = nft.name.split(separator: " ").first {
            nameLabel.text = String(firstWord)
        } else {
            nameLabel.text = nft.name
        }

        setupRatingStars(rating: nft.rating)
        priceLabel.text = "\(nft.price) ETH"

        heartButton.isSelected = true
        heartButton.tintColor = .yaRedUniversal
    }

    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .yaSecondary
        layer.cornerRadius = 8
        clipsToBounds = true

        contentView.addSubview(nftImageView)
        contentView.addSubview(heartButton)
        contentView.addSubview(textStackView)

        textStackView.addArrangedSubview(nameLabel)
        textStackView.addArrangedSubview(ratingStackView)
        textStackView.addArrangedSubview(priceLabel)

        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 80),
            nftImageView.heightAnchor.constraint(equalToConstant: 80),

            heartButton.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 4),
            heartButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: -4),
            heartButton.widthAnchor.constraint(equalToConstant: 21),
            heartButton.heightAnchor.constraint(equalToConstant: 18),

            textStackView.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 7),
            textStackView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 8),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            textStackView.heightAnchor.constraint(equalToConstant: 66),

            ratingStackView.heightAnchor.constraint(equalToConstant: 12),
            ratingStackView.widthAnchor.constraint(equalToConstant: 68)
        ])
    }

    private func setupRatingStars(rating: Double) {
        let clampedRating = max(0.0, min(5.0, rating))
        let stars = ratingStackView.arrangedSubviews.compactMap { $0 as? UIImageView }

        for (index, starImageView) in stars.enumerated() {
            let starIndex = Double(index)
            if clampedRating >= starIndex + 1 {
                starImageView.image = UIImage(systemName: "star.fill")
                starImageView.tintColor = .yaYellowUniversal
            } else if clampedRating > starIndex {
                starImageView.image = UIImage(systemName: "star.leadinghalf.filled")
                starImageView.tintColor = .yaYellowUniversal
            } else {
                starImageView.image = UIImage(systemName: "star")
                starImageView.tintColor = .yaLightGray
            }
        }
    }

    private func makeStarImageViews(in stackView: UIStackView) {
        for _ in 0..<5 {
            let starImageView = UIImageView()
            starImageView.contentMode = .scaleAspectFit
            starImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
            stackView.addArrangedSubview(starImageView)
        }
    }

    // MARK: - Actions
    @objc
    private func heartButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        sender.tintColor = sender.isSelected ? .yaRedUniversal : .yaWhiteUniversal
        onHeartButtonTapped?(sender.isSelected)
    }
}
