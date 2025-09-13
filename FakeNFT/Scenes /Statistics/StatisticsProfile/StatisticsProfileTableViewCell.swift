import UIKit

final class StatisticsProfileTableViewCell: UITableViewCell {
    // MARK: private properties
    var titleString: String?
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
   init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, titleString: String) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.titleString = titleString
        configureCell()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configureCell() {
        selectionStyle = .none
        contentView.addSubview(collectionLabel)
        collectionLabel.text = titleString
        NSLayoutConstraint.activate([
            collectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)])
        contentView.addSubview(chevronImageView)
        NSLayoutConstraint.activate([
            chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)])
    }
}
