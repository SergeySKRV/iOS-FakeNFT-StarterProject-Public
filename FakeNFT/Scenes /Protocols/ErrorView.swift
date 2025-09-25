import UIKit

/// Модель данных для отображения ошибки.
///
/// Используется для передачи сообщения и действий,
/// которые должны быть выполнены при нажатии на кнопку в алерте.
struct ErrorModel {
    /// Текст ошибки, отображаемый в алерте.
    let message: String

    /// Текст кнопки действия.
    let actionText: String

    /// Действие, выполняемое при нажатии на кнопку.
    let action: () -> Void
}

/// Протокол для отображения ошибок в виде алертов.
///
/// Обычно реализуется `UIViewController`,
/// чтобы унифицировать работу с ошибками в приложении.
protocol ErrorView {
    /// Отображает ошибку в соответствии с переданной моделью.
    /// - Parameter model: Модель ошибки (`ErrorModel`).
    func showError(_ model: ErrorModel)
}

// MARK: - Default Implementation

extension ErrorView where Self: UIViewController {

    /// Отображает стандартный `UIAlertController` с сообщением об ошибке.
    ///
    /// - Parameter model: Модель ошибки (`ErrorModel`), включающая:
    ///   - сообщение (`message`),
    ///   - текст кнопки (`actionText`),
    ///   - действие (`action`).
    func showError(_ model: ErrorModel) {
        let title = NSLocalizedString("Error.title", comment: "Заголовок ошибки")
        let alert = UIAlertController(
            title: title,
            message: model.message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: model.actionText,
            style: .default
        ) { _ in
            model.action()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}
