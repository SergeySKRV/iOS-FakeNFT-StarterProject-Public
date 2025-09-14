import UIKit

final class StatisticsProfileViewPresenter {
    // MARK: - private properties
    static let shared = StatisticsProfileViewPresenter()
    weak var view: StatisticsProfileViewController?
    // MARK: - public methods
    func viewDidLoad() {
        view?.setupNavigationBar()
    }
    func showWebView() {
        let webViewController = WebViewController(urlString: StatisticsConstants.webViewURL)
        if let navController = view?.navigationController {
            navController.pushViewController(webViewController, animated: true)
        } else {
            let navController = UINavigationController(rootViewController: webViewController)
            navController.modalPresentationStyle = .fullScreen
            view?.present(navController, animated: true)
        }
    }
    func showNFTCollection() {
        let collectionViewController = StatisticsCollectionViewController()
        if let navController = view?.navigationController {
            navController.pushViewController(collectionViewController, animated: true)
        } else {
            let navController = UINavigationController(rootViewController: collectionViewController)
            navController.modalPresentationStyle = .fullScreen
            view?.present(navController, animated: true)
        }
    }
    // MARK: - private methods
    private init() {
    }
}
