//
//  CollectionViewCell.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 01.09.2025.
//

import UIKit
import Kingfisher

protocol CollectionViewCellDelegate: AnyObject {
    func likeButtonDidChange(for indexPath: IndexPath, isLiked: Bool)
    func cartButtonDidChange(for indexPath: IndexPath)
}

final class CollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    // MARK: - Public Properties
    static let identifier = "CollectionCell"
    
    var nftModel: NFTs?
    var indexPath: IndexPath?
    weak var delegate: CollectionViewCellDelegate?
    
    
    // MARK: - Private Properties
    private var isLiked: Bool = true
    private lazy var ratingView = RatingView()
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = Constants.cornerRadius
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(named: "likeNoActive")
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: Constants.likeButtonInsetsTopBottom,
            leading: Constants.likeButtonInsetsLeft,
            bottom: Constants.likeButtonInsetsTopBottom,
            trailing: Constants.likeButtonInsetsRight
        )
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        
        button.addTarget(
            self,
            action: #selector (likeButtonTapped),
            for: .touchUpInside)
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
    
    private lazy var cartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = .textPrimary
        button.imageView?.contentMode = .scaleAspectFill
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.clipsToBounds = true
        
        button.addTarget(
            self,
            action: #selector (cartButtonTapped),
            for: .touchUpInside)
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
    
    // MARK: - Actions
    @objc
    func likeButtonTapped() {
        isLiked.toggle()
       
        let imageName = isLiked ? "likeActive" : "likeNoActive"
        likeButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    @objc
    func cartButtonTapped() {
        isLiked.toggle()
       
        let imageName = isLiked ? "inCart" : "notInCart"
       
        cartButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    // MARK: - Public Methods
    func configCollectionCell(nftModel: NFTCellModel) {
        DispatchQueue.main.async {
            self.nftImageView.kf.setImage(with: nftModel.image)
            self.nftName.text = nftModel.name
            self.nftPrice.text = "\(nftModel.price) ETH"
            self.ratingView.createRating(with: nftModel.rating)
            self.cartButton.setImage(self.setIsCart(isInCart: nftModel.isInCart), for: .normal)
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
            cartButton
        ].forEach {
            contentView.addSubview(
                $0
            )
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setIsCart(isInCart: Bool) -> UIImage? {
        isInCart
        ? UIImage(named: "inCart")
        : UIImage(named: "notInCart")
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
            
            
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.cartButtonTopIdent),
            
            cartButton.heightAnchor.constraint(equalToConstant: Constants.cartButtonHeigthWidth),
            cartButton.widthAnchor.constraint(equalToConstant: Constants.cartButtonHeigthWidth)
             
        ])
    }
}
