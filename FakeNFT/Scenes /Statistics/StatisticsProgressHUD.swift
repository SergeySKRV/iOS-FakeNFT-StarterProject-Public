import ProgressHUD
import UIKit

final class StatisticsUIBlockingProgressHUD {
    // MARK: - private properties
    private static var window: UIWindow? {
        return UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
    }
    // MARK: - public methods
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
