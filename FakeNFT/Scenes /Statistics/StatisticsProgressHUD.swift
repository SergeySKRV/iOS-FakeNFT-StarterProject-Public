import UIKit
import ProgressHUD

final class StatisticsUIBlockingProgressHUD {
    
    //MARK: private properties
    
    private static var window: UIWindow? {
        UIApplication.shared.windows.first
    }
    
    //MARK: public methods
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
