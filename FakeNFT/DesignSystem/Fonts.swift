import UIKit

struct Fonts {
    // MARK: - Bold Fonts
    static let sfProBold34 = UIFont(name: "SFProText-Bold", size: 34) ?? UIFont.systemFont(ofSize: 34, weight: .bold)
    static let sfProBold28 = UIFont(name: "SFProText-Bold", size: 28) ?? UIFont.systemFont(ofSize: 28, weight: .bold)
    static let sfProBold22 = UIFont(name: "SFProText-Bold", size: 22) ?? UIFont.systemFont(ofSize: 22, weight: .bold)
    static let sfProBold20 = UIFont(name: "SFProText-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
    static let sfProBold17 = UIFont(name: "SFProText-Bold", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .bold)
    
    // MARK: - Regular Fonts
    static let sfProRegular17 = UIFont(name: "SFProText-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .regular)
    static let sfProRegular15 = UIFont(name: "SFProText-Regular", size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .regular)
    static let sfProRegular13 = UIFont(name: "SFProText-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .regular)
}

extension UIFont {
    // Ниже приведены примеры шрифтов, настоящие шрифты надо взять из фигмы

    // Headline Fonts
    static var headline1 = UIFont.systemFont(ofSize: 34, weight: .bold)
    static var headline2 = UIFont.systemFont(ofSize: 28, weight: .bold)
    static var headline3 = UIFont.systemFont(ofSize: 22, weight: .bold)
    static var headline4 = UIFont.systemFont(ofSize: 20, weight: .bold)

    // Body Fonts
    static var bodyRegular = UIFont.systemFont(ofSize: 17, weight: .regular)
    static var bodyBold = UIFont.systemFont(ofSize: 17, weight: .bold)

    // Caption Fonts
    static var caption1 = UIFont.systemFont(ofSize: 15, weight: .regular)
    static var caption2 = UIFont.systemFont(ofSize: 13, weight: .regular)
}
