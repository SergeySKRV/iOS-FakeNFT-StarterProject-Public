//
//  CollectionViewCell.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 01.09.2025.
//

import UIKit
import Kingfisher

final class CollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    // MARK: - Public Properties
    static let identifier = "CollectionCell"
    
    var nftModel: NFTs?
    
    // MARK: - Private Properties
    private lazy var ratingView = RatingView()
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = Constants.cornerRadius
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = .yaWhiteUniversal
        button.contentEdgeInsets = UIEdgeInsets(
            top: Constants.likeButtonInsetsTopBottom,
            left: Constants.likeButtonInsetsLeft,
            bottom: Constants.likeButtonInsetsTopBottom,
            right: Constants.likeButtonInsetsRight)
        // TODO: - добавить таргет
        return button
    }()
    
    private lazy var nftName: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .textPrimary
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var nftPrice: UILabel = {
        let label = UILabel()
        label.font = .medium10
        label.textColor = .textPrimary
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var cardButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "Cart"), for: .normal)
        button.tintColor = .textPrimary
        // TODO: - добавить таргет
        return button
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionViewCell()
        setupCollectionViewConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configCollectionCell(nftModel: NFTCellModel) {
        DispatchQueue.main.async {
            self.nftImageView.kf.setImage(with: nftModel.image)
            self.nftName.text = nftModel.name
            self.nftPrice.text = "\(nftModel.price) ETH"
            self.ratingView.createRating(with: nftModel.rating)
        }
    }
    
    // MARK: - Private Methods
    private func setupCollectionViewCell() {
        [
            ratingView,
            nftImageView,
            likeButton,
            nftName,
            nftPrice,
            cardButton
        ].forEach {
            contentView.addSubview(
                $0
            )
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupCollectionViewConstrains() {
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImageView.heightAnchor.constraint(equalToConstant: Constants.nftImageViewHeigth),
            
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.likeButtonTopIdent),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.likeButtonTrailing),
            likeButton.heightAnchor.constraint(equalToConstant: Constants.likeButtonHeigthWidth),
            likeButton.widthAnchor.constraint(equalToConstant: Constants.likeButtonHeigthWidth),
            
            ratingView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: Constants.ratingViewTopIdent),
            ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingView.heightAnchor.constraint(equalToConstant: Constants.ratingViewHeigth),
            ratingView.widthAnchor.constraint(equalToConstant: Constants.ratingViewWidth),
            
            nftName.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: Constants.nftNameTopIdent),
            nftName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftName.heightAnchor.constraint(equalToConstant: Constants.nftNameHeigth),
            nftName.widthAnchor.constraint(equalToConstant: Constants.nftNameWidth),
            
            nftPrice.topAnchor.constraint(equalTo: nftName.bottomAnchor, constant: Constants.nftPriceTopIdent),
            nftPrice.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            cardButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.cardButtonTopIdent),
            cardButton.heightAnchor.constraint(equalToConstant: Constants.cardButtonHeigthWidth),
            cardButton.widthAnchor.constraint(equalToConstant: Constants.cardButtonHeigthWidth)
        ])
    }
}

