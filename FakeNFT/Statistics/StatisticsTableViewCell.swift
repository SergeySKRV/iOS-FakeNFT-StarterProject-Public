
import UIKit

final class StatisticsTableViewCell: UITableViewCell {
    
    //TODO: взять цвета из фигмы
    
    
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let profileRectView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileAvatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let profileNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let profileNFTCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    //    configureCellData()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    func configureView()
    {
        contentView.addSubview(numberLabel)
        NSLayoutConstraint.activate([
            numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            numberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5)
        ])
        contentView.addSubview(profileRectView)
        NSLayoutConstraint.activate([
            profileRectView.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileRectView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35),
            profileRectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileRectView.heightAnchor.constraint(equalTo: heightAnchor, constant: -8)
        ])
        
        contentView.addSubview(profileAvatarImageView)
        NSLayoutConstraint.activate([
            profileAvatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileAvatarImageView.leadingAnchor.constraint(equalTo: profileRectView.leadingAnchor, constant: 16)
        ])
        contentView.addSubview(profileNameLabel)
        NSLayoutConstraint.activate([
            profileNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileNameLabel.leadingAnchor.constraint(equalTo: profileAvatarImageView.trailingAnchor,constant: 8),
            profileNameLabel.widthAnchor.constraint(equalToConstant: 186)
        ])
        contentView.addSubview(profileNFTCountLabel)
        NSLayoutConstraint.activate([
            profileNFTCountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileNFTCountLabel.trailingAnchor.constraint(equalTo: profileRectView.trailingAnchor, constant: -16)
        ])
    }
    func configureCellData(number: Int, avatarImage: UIImage, nameOfUser: String, numberOfNFT: Int) {
        numberLabel.text = "\(number)"
        profileAvatarImageView.image = avatarImage
        profileNameLabel.text = nameOfUser
        profileNFTCountLabel.text = "\(numberOfNFT)"
    }
}
