import Foundation
import UIKit

final class StatisticsCollectionPresenter {
    static let shared = StatisticsCollectionPresenter()
    var statisticsCollectionViewModel: [StatistiscsNFTModel]
    private let stubNFT1: StatistiscsNFTModel = .init(
        image: UIImage(resource: .archie),
        name: "Archie",
        price: 1.72,
        rating: 1,
        id: "1",
        isLike: false,
        isInCart: false
    )
    private let stubNFT2: StatistiscsNFTModel = .init(
        image: UIImage(resource: .emma),
        name: "Emma",
        price: 1.72,
        rating: 2,
        id: "2",
        isLike: false,
        isInCart: false
    )
    private let stubNFT3: StatistiscsNFTModel = .init(
        image: UIImage(resource: .stella),
        name: "Stella",
        price: 1.72,
        rating: 3,
        id: "3",
        isLike: false,
        isInCart: false
    )
    private let stubNFT4: StatistiscsNFTModel = .init(
        image: UIImage(resource: .toast),
        name: "Toast",
        price: 1.72,
        rating: 4,
        id: "4",
        isLike: false,
        isInCart: false
    )
    private let stubNFT5: StatistiscsNFTModel = .init(
        image: UIImage(resource: .zeus),
        name: "Zeus",
        price: 1.72,
        rating: 5,
        id: "5",
        isLike: false,
        isInCart: false
    )
    
    private init() {
        statisticsCollectionViewModel = [stubNFT1, stubNFT2, stubNFT3, stubNFT4, stubNFT5]
    }
}
