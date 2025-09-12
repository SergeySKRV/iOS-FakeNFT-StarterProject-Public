import UIKit

final class DeletePopupViewController: UIViewController {
    
    var nftImageURL: String?
    var nftImage: UIImage?
    var nftName: String?
    var onDelete: (() -> Void)?
    var onCancel: (() -> Void)?
    
    private let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Вы уверены, что хотите удалить объект из корзины?"
        label.font = UIFont.systemFont(ofSize: 13)
        label.font = UIFont(name: "SFProText-Regular", size: 13)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Вернуться", for: .normal)
        button.setTitleColor(UIColor(named: "ypWhite"), for: .normal)
        button.backgroundColor = UIColor(named: "ypBlack")
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if let font = UIFont(name: "SFProText-Regular", size: 17) {
            button.titleLabel?.font = font
        } else {
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        }
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(UIColor(named: "ypRed"), for: .normal)
        button.backgroundColor = UIColor(named: "ypBlack")
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if let font = UIFont(name: "SFProText-Regular", size: 17) {
            button.titleLabel?.font = font
        } else {
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        }
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        configureContent()
    }
    
    private func setupView() {
        view.backgroundColor = .clear
        
        view.addSubview(blurView)
        view.addSubview(containerView)
        
        containerView.addSubview(nftImageView)
        containerView.addSubview(messageLabel)
        containerView.addSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(deleteButton)
        buttonStackView.addArrangedSubview(cancelButton)
        
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 56),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -57),
            
            nftImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            nftImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            
            messageLabel.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 41),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -41),
            
            buttonStackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            buttonStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            buttonStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            buttonStackView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func configureContent() {
        if let imageURL = nftImageURL, let url = URL(string: imageURL) {
            loadImage(from: url)
        }
        else if let image = nftImage {
            nftImageView.image = image
        }
        else {
            nftImageView.image = UIImage(systemName: "photo")
        }
    }
    
    @objc private func deleteTapped() {
        dismiss(animated: true) {
            self.onDelete?()
        }
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true) {
            self.onCancel?()
        }
    }
    
    private func loadImage(from url: URL) {
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async {
                self?.nftImageView.image = image
            }
        }.resume()
    }
}
