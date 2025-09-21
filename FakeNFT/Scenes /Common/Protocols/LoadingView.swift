import ProgressHUD
import UIKit

/// Протокол для отображения индикатора загрузки.
///
/// Используется во `ViewController`, где требуется
/// показать или скрыть индикатор активности при сетевых операциях.
protocol LoadingView {
    /// Индикатор активности, связанный с текущим экраном.
    var activityIndicator: UIActivityIndicatorView { get }

    /// Отображает индикатор загрузки.
    func showLoading()

    /// Скрывает индикатор загрузки.
    func hideLoading()
}

// MARK: - Default Implementation

extension LoadingView {
    /// Запускает анимацию индикатора.
    func showLoading() {
        activityIndicator.startAnimating()
    }

    /// Останавливает анимацию индикатора.
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
}
