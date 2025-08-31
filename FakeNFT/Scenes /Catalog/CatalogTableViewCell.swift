//
//  CatalogTableViewCell.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 30.08.2025.
//

import UIKit
import Kingfisher

final class CatalogTableViewCell: UITableViewCell, ReuseIdentifying {
    // MARK: - Public Properties
    static let identifier = "CatalogCell"
    
    // MARK: - Private Properties
    private lazy var catalogImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var catalogLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .textPrimary
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Overrides Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupCatalogTableViewCell()
    }
    
    // MARK: - Initializers
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func setCatalogImage(with collectionCover: URL) {
        catalogImage.kf.indicatorType = .activity
        catalogImage.kf.setImage(with: collectionCover)
    }
    
    func setCatalogLabel(with name: String, quantity count: Int ) {
        catalogLabel.text = "\(name) (\(count))"
    }
    
    // MARK: - Private Methods
    private func setupCatalogTableViewCell() {
        backgroundColor = .clear
        selectionStyle = .none
        addSubviews()
        setupCatalogTableViewCellConstrains()
    }
    
    private func addSubviews() {
        [catalogImage, catalogLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func setupCatalogTableViewCellConstrains() {
        NSLayoutConstraint.activate([
            catalogImage.heightAnchor.constraint(equalToConstant: 140),
            catalogImage.topAnchor.constraint(equalTo: topAnchor),
            catalogImage.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            catalogImage.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            catalogLabel.topAnchor.constraint(equalTo: catalogImage.bottomAnchor, constant: 4),
            catalogLabel.bottomAnchor.constraint(equalTo: catalogImage.bottomAnchor, constant: 25),
            catalogLabel.leadingAnchor.constraint(equalTo: catalogImage.leadingAnchor),
            catalogLabel.trailingAnchor.constraint(equalTo: catalogImage.trailingAnchor),
            catalogLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
}


