import UIKit

final class PaymentMethodCell: UICollectionViewCell {
    static let reuseIdentifier = "PaymentMethodCell"
    
    private lazy var contentContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .ypLightGrey)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var iconContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .ypBlack)
        view.layer.cornerRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.sfProRegular13
        label.textColor = UIColor(resource: .ypBlack)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var symbolLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.sfProRegular13
        label.textColor = UIColor(resource: .ypGreen)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.backgroundColor = .clear
        
        labelsStackView.addArrangedSubview(nameLabel)
        labelsStackView.addArrangedSubview(symbolLabel)
        
        iconContainer.addSubview(iconImageView)
        
        contentContainer.addSubview(iconContainer)
        contentContainer.addSubview(labelsStackView)
        
        contentView.addSubview(contentContainer)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            iconContainer.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 12),
            iconContainer.centerYAnchor.constraint(equalTo: contentContainer.centerYAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: 36),
            iconContainer.heightAnchor.constraint(equalToConstant: 36),
            
            iconImageView.topAnchor.constraint(equalTo: iconContainer.topAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: iconContainer.leadingAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: iconContainer.trailingAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: iconContainer.bottomAnchor),
            
            labelsStackView.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 4),
            labelsStackView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -12),
            labelsStackView.centerYAnchor.constraint(equalTo: contentContainer.centerYAnchor),
            
            contentView.heightAnchor.constraint(equalToConstant: 46)
        ])
    }
    
    func configure(with method: PaymentMethod) {
        loadImage(from: method.currency.image)
        nameLabel.text = method.currency.displayName
        symbolLabel.text = method.currency.symbol
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            iconImageView.image = UIImage(named: "placeholder_icon")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self?.iconImageView.image = UIImage(named: "placeholder_icon")
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.iconImageView.image = UIImage(data: data)
            }
        }.resume()
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                contentView.layer.borderColor = UIColor(resource: .ypBlack).cgColor
                contentView.layer.borderWidth = 1
                contentView.layer.cornerRadius = 12
            } else {
                contentView.layer.borderColor = UIColor(resource: .ypLightGrey).cgColor
                contentView.layer.borderWidth = 1
            }
        }
    }
}
