import Foundation

final class StatisticsProfileViewPresenter {
    static let shared = StatisticsProfileViewPresenter()
    weak var view: StatisticsProfileViewController?
    
    func showWebView() {
        let webViewController = WebViewController(urlString: "https://practicum.yandex.ru/ios-developer")
        webViewController.modalPresentationStyle = .fullScreen
        view?.present(webViewController, animated: true)
    }
    func showNFTCollection() {
        let collectionViewController = StatisticsCollectionViewController()
        collectionViewController.modalPresentationStyle = .fullScreen
        view?.present(collectionViewController, animated: true)
    }
}
