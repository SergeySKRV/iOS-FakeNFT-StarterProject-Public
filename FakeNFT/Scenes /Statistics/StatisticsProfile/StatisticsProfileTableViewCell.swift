import UIKit

final class StatisticsProfileTableViewCell: UITableViewCell {
    // MARK: - public properties
    var nftCount: Int?
    // MARK: - private properties
    private let collectionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.sfProBold17
        label.textColor = UIColor.yaPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .chevronForward ))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    // MARK: - public methods
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, nftCount: Int) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.nftCount = nftCount
        configureCell()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - private methods
    private func configureCell() {
        selectionStyle = .none
        contentView.addSubview(collectionLabel)
        if nftCount ?? 0 > 0 {
            collectionLabel.textColor = UIColor.yaPrimary
        } else {
            collectionLabel.textColor = UIColor.yaGrayUniversal
        }
        collectionLabel.text = "Коллекция NFT (\(nftCount ?? 0))"
        NSLayoutConstraint.activate([
            collectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)])
        contentView.addSubview(chevronImageView)
        NSLayoutConstraint.activate([
            chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)])
    }
}
