import UIKit

final class RatingView: UIStackView {
    private var starImageViews: [UIImageView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        axis = .horizontal
        spacing = 2
        
        for _ in 0..<5 {
            let starImageView = UIImageView()
            starImageView.contentMode = .scaleAspectFit
            starImageView.tintColor = .systemYellow
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
            addArrangedSubview(starImageView)
            starImageViews.append(starImageView)
        }
    }
    
    func setRating(_ rating: Int) {
        for (index, starImageView) in starImageViews.enumerated() {
            starImageView.image = UIImage(systemName: index < rating ? "star.fill" : "star")
        }
    }
}
