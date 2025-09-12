import Foundation

final class StatisticsProfileViewPresenter {
    static let shared = StatisticsProfileViewPresenter()
    weak var view: StatisticsProfileViewController?
    
   func showWebView() {
       let webViewController = WebViewController(urlString: "https://practicum.yandex.ru/ios-developer")
       webViewController.modalPresentationStyle = .fullScreen
       view?.present(webViewController, animated: true)
    }
}
