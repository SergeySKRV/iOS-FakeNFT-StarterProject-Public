//
//  MyNFTTableViewCell.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 07.09.2025.
//

import UIKit
import Kingfisher

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
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.sfProBold17
        label.textColor = .yaPrimary
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Rating Stars
    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.setContentHuggingPriority(.required, for: .horizontal)
   
        for _ in 0..<5 {
            let starImageView = UIImageView()
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starImageView.contentMode = .scaleAspectFit

            starImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
            
            stackView.addArrangedSubview(starImageView)
        }
        
        return stackView
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.sfProRegular13
        label.textColor = .yaPrimary
        label.textAlignment = .left
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.sfProBold17
        label.textColor = .yaPrimary
        label.textAlignment = .left
        return label
    }()
    
    private lazy var priceTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.sfProRegular13
        label.textColor = .yaPrimary
        label.textAlignment = .right
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
    func configure(with nft: NFTItem, mockImage: UIImage? = nil) {
        if let mockImage = mockImage {
            nftImageView.image = mockImage
        } else {
            nftImageView.kf.setImage(with: nft.imageUrl)
        }
        
        nameLabel.text = nft.name
        
        setupRatingStars(rating: nft.rating)
        
        authorLabel.text = "от \(nft.author)"
        priceLabel.text = nft.price
        priceTitleLabel.text = "Цена"
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(nftImageView)
        contentView.addSubview(heartButton)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ratingStackView)
        contentView.addSubview(authorLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(priceTitleLabel)
        
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
            
            nameLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 23),
            nameLabel.trailingAnchor.constraint(equalTo: priceTitleLabel.leadingAnchor, constant: -8),
            
            ratingStackView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            ratingStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingStackView.heightAnchor.constraint(equalToConstant: 16),
            
            authorLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            authorLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 4),
            authorLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            priceTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -83),
            priceTitleLabel.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 33),
            
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -42),
            priceLabel.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 53),
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
    @objc private func heartButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        sender.tintColor = sender.isSelected ? .yaRedUniversal : .textOnPrimary
        print("Кнопка сердца нажата. Выбрано: \(sender.isSelected)")
        // TODO: Добавить логику для обработки добавления/удаления из избранного
    }
}
