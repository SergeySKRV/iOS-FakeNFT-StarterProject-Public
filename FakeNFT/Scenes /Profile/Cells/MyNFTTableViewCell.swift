//
//  MyNFTTableViewCell.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 07.09.2025.
//

import Kingfisher
import UIKit

// MARK: - MyNFTTableViewCell
final class MyNFTTableViewCell: UITableViewCell, ReuseIdentifying {
    // MARK: - UI Elements
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.backgroundColor = .yaSecondary
        return imageView
    }()

    private lazy var heartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        let heartImage = UIImage(resource: .heartfavorites).withRenderingMode(.alwaysTemplate)
        button.setImage(heartImage, for: .normal)
        button.setImage(heartImage, for: .selected)
        button.tintColor = .yaWhiteUniversal
        button.contentMode = .scaleAspectFit
        return button
    }()

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        return stackView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.sfProBold17
        label.textColor = .yaPrimary
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    // MARK: - Rating Stars
    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.setContentHuggingPriority(.required, for: .horizontal)

        for _ in 0..<5 {
            let starImageView = UIImageView()
            starImageView.contentMode = .scaleAspectFit
            starImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
            stackView.addArrangedSubview(starImageView)
        }
        return stackView
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.sfProRegular13
        label.textColor = .yaPrimary
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        return stackView
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.sfProBold17
        label.textColor = .yaPrimary
        label.textAlignment = .left
        return label
    }()

    private lazy var priceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.sfProRegular13
        label.textColor = .yaPrimary
        label.textAlignment = .left
        return label
    }()

    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }

    // MARK: - Public Methods
    func configure(with nft: NFTItem) {
        nftImageView.kf.setImage(with: nft.imageUrl)
        nameLabel.text = nft.name
        setupRatingStars(rating: nft.rating)
        authorLabel.text = nft.author
        priceLabel.text = nft.price
        priceTitleLabel.text = NSLocalizedString("price", comment: "Price label title")
    }

    // MARK: - Private Methods
    private func setupUI() {
        contentView.backgroundColor = .yaSecondary
        contentView.addSubview(nftImageView)
        contentView.addSubview(heartButton)
        contentView.addSubview(textStackView)
        textStackView.addArrangedSubview(nameLabel)
        textStackView.addArrangedSubview(ratingStackView)
        textStackView.addArrangedSubview(authorLabel)
        contentView.addSubview(priceStackView)
        priceStackView.addArrangedSubview(priceTitleLabel)
        priceStackView.addArrangedSubview(priceLabel)
        heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),

            heartButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: -8),
            heartButton.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 8),
            heartButton.widthAnchor.constraint(equalToConstant: 24),
            heartButton.heightAnchor.constraint(equalToConstant: 24),

            textStackView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            textStackView.widthAnchor.constraint(equalToConstant: 90),
            textStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textStackView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 10),
            textStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),

            priceStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -39),
            priceStackView.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 33),
            priceStackView.widthAnchor.constraint(equalToConstant: 91),
            priceStackView.heightAnchor.constraint(equalToConstant: 42)
        ])
        contentView.heightAnchor.constraint(equalToConstant: 140).isActive = true
    }

    private func setupRatingStars(rating: Int) {
        let clampedRating = max(0, min(5, rating))
        let stars = ratingStackView.arrangedSubviews.compactMap { $0 as? UIImageView }
        for (index, starImageView) in stars.enumerated() {
            if index < clampedRating {
                starImageView.image = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate)
                starImageView.tintColor = .yaYellowUniversal
            } else {
                starImageView.image = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate)
                starImageView.tintColor = .yaLightGray
            }
        }
    }

    // MARK: - Actions
    @objc
    private func heartButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        sender.tintColor = sender.isSelected ? .yaRedUniversal : .textOnPrimary
        // TODO: Добавить логику для обработки добавления/удаления из избранного
    }
}
