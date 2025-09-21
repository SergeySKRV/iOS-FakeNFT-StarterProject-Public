import UIKit
import Kingfisher

final class StatisticsCollectionViewCell: UICollectionViewCell {
    var presenter: StatisticsCollectionPresenter?
    var nftCard: StatisticsNFTModel?
    // MARK: - private properties
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(likeButtonTouch), for: .touchUpInside)
        return button
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
    private let cartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cartButtonTouch), for: .touchUpInside)
        return button
    }()
    // MARK: - public methods
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
        contentView.addSubview(likeButton)
        NSLayoutConstraint.activate([
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: -12),
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 12)])
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
        contentView.addSubview(cartButton)
        NSLayoutConstraint.activate([
            cartButton.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 40),
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)])
    }
    func configureCellData() {
        guard let nftCard = nftCard else { return }
        nftImageView.kf.indicatorType = .activity
        nftImageView.kf.setImage(with: URL(string: nftCard.image))
        let likeImage = nftCard.isLike ? UIImage(resource: .statisticsLikeActive) :
        UIImage(resource: .statisticsLikeNoActive)
        likeButton.setImage(likeImage, for: .normal)
        switch nftCard.rating {
        case 0: ratingImage.image = UIImage(resource: .statisticsRating0)
        case 1: ratingImage.image = UIImage(resource: .statisticsRating1)
        case 2: ratingImage.image = UIImage(resource: .statisticsRating2)
        case 3: ratingImage.image = UIImage(resource: .statisticsRating3)
        case 4: ratingImage.image = UIImage(resource: .statisticsRating4)
        case 5: ratingImage.image = UIImage(resource: .statisticsRating5)
        default: ratingImage.image = UIImage(resource: .statisticsRating0)
        }
        nameLabel.text = nftCard.name.components(separatedBy: " ")[0]
        priceLabel.text = "\(nftCard.price) ETH"
        let cartImage = nftCard.isInCart ? UIImage(resource: .statisticsCartActive) :
        UIImage(resource: .statisticsCartNoActive)
        cartButton.setImage(cartImage, for: .normal)
    }
    @objc func likeButtonTouch() {
        presenter?.likeButtonTouch(nftID: nftCard?.id ?? "")
        self.nftCard?.isLike.toggle()
        configureCellData()
    }
    @objc func cartButtonTouch() {
        presenter?.cartButtonTouch(nftID: nftCard?.id ?? "")
        nftCard?.isInCart.toggle()
        configureCellData()
    }
}
