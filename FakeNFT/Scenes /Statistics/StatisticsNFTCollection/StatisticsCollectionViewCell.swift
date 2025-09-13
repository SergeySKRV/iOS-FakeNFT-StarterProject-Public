import UIKit
import Kingfisher

final class StatisticsCollectionViewCell: UICollectionViewCell {
    // MARK: private properties
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let likeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let ratingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.sfProBold17
        label.textColor = UIColor.yaPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.sfProMedium10
        label.textColor = UIColor.yaPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let cartImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    // MARK: public methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureView() {
        backgroundColor = .clear
        contentView.addSubview(nftImageView)
        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108)])
        contentView.addSubview(likeImage)
        NSLayoutConstraint.activate([
            likeImage.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: -12),
            likeImage.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 12)])
        contentView.addSubview(ratingImage)
        NSLayoutConstraint.activate([
            ratingImage.leadingAnchor.constraint(equalTo: nftImageView.leadingAnchor),
            ratingImage.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8)])
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: ratingImage.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: ratingImage.bottomAnchor, constant: 5)])
        contentView.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4)])
        contentView.addSubview(cartImage)
        NSLayoutConstraint.activate([
            cartImage.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 40),
            cartImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)])
    }
    func configureCellData(nftCart: StatistiscsNFTModel) {
        nftImageView.image = nftCart.image
        likeImage.image = nftCart.isLike ? UIImage(resource: .statisticsLikeActive) :
        UIImage(resource: .statisticsLikeNoActive)
        switch nftCart.rating {
        case 0: ratingImage.image = UIImage(resource: .statisticsRating0)
        case 1: ratingImage.image = UIImage(resource: .statisticsRating1)
        case 2: ratingImage.image = UIImage(resource: .statisticsRating2)
        case 3: ratingImage.image = UIImage(resource: .statisticsRating3)
        case 4: ratingImage.image = UIImage(resource: .statisticsRating4)
        case 5: ratingImage.image = UIImage(resource: .statisticsRating5)
        default: ratingImage.image = UIImage(resource: .statisticsRating0)
        }
        nameLabel.text = nftCart.name
        priceLabel.text = "\(nftCart.price) ETH"
        cartImage.image  = nftCart.isInCart ? UIImage(resource: .statisticsCartActive) :
        UIImage(resource: .statisticsCartNoActive)
    }
}
