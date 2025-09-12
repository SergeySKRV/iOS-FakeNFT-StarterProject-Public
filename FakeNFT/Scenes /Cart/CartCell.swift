import UIKit

final class CartCell: UITableViewCell {
    static let reuseIdentifier = "CartCell"
    
    private var currentImage: UIImage?
    
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProText-Bold", size: 17)
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingView: RatingView = {
        let view = RatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let priceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Цена"
        label.font = UIFont(name: "SFProText-Regular", size: 13)
        label.textColor = UIColor(named: "ypBlack")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProText-Bold", size: 17)
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "cartDelete"), for: .normal)
        button.tintColor = UIColor(named: "ypBlack")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(nftImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ratingView)
        contentView.addSubview(priceTitleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(deleteButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteButton.widthAnchor.constraint(equalToConstant: 40),
            deleteButton.heightAnchor.constraint(equalToConstant: 40),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: deleteButton.leadingAnchor, constant: -8),
            
            ratingView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 16),
            
            priceTitleLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 12),
            priceTitleLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 16),
            
            priceLabel.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 2),
            priceLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(lessThanOrEqualTo: deleteButton.leadingAnchor, constant: -8),
            
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: priceLabel.bottomAnchor, constant: 16)
        ])
    }
    
    func configure(with item: CartItem) {
        nameLabel.text = item.name
        priceLabel.text = String(format: "%.2f \(item.currency)", item.price)
        ratingView.setRating(item.rating)
        
        nftImageView.image = UIImage(systemName: "photo")
        nftImageView.backgroundColor = .lightGray
        
        //        let activityIndicator = UIActivityIndicatorView(style: .medium)
        //        activityIndicator.startAnimating()
        //        nftImageView.addSubview(activityIndicator)
        //        activityIndicator.center = nftImageView.center
        
        loadImage(from: item.image)
        currentImage = nftImageView.image
    }
    
    func getNFTImage() -> UIImage? {
        return currentImage ?? nftImageView.image
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async {
                self.nftImageView.image = image
                self.nftImageView.backgroundColor = .clear
            }
        }.resume()
    }
}
