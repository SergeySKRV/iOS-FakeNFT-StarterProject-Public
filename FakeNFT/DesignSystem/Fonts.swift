import UIKit

extension UIFont {
    // Ниже приведены примеры шрифтов, настоящие шрифты надо взять из фигмы
    
    // Headline Fonts
    static var sfProHeadline1 = UIFont(name: "SFProDisplay-Bold", size: 34) ?? UIFont.systemFont(ofSize: 34, weight: .bold)
    static var sfProHeadline2 = UIFont(name: "SFProDisplay-Bold", size: 28) ?? UIFont.systemFont(ofSize: 28, weight: .bold)
    static var sfProHeadline3 = UIFont(name: "SFProDisplay-Bold", size: 22) ?? UIFont.systemFont(ofSize: 22, weight: .bold)
    static var sfProHeadline4 = UIFont(name: "SFProDisplay-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
    
    // Body Fonts
    static var sfProBodyRegular = UIFont(name: "SFProText-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .regular)
    static var sfProBodyBold = UIFont(name: "SFProText-Bold", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .bold)
    
    // Caption Fonts
    static var sfProCaption1 = UIFont(name: "SFProText-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .regular)
    static var sfProCaption2 = UIFont(name: "SFProText-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .regular)
    
    // MARK: - Medium Fonts
        static let sfProMedium10 = UIFont(name: "SFProText-Medium", size: 10) ?? UIFont.systemFont(ofSize: 10, weight: .medium)
}

