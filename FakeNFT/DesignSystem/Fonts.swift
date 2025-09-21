import UIKit

/// Содержит предустановленные шрифты для приложения.
///
/// Все шрифты построены на базе семейства `SF Pro Text`.
/// Если системный шрифт не найден (например, отсутствует в iOS),
/// автоматически подставляется ближайший системный шрифт с тем же размером и весом.
struct Fonts {

    // MARK: - Bold Fonts

    /// Жирный шрифт `SFProText-Bold`, размер 34pt.
    static let sfProBold34 = UIFont(name: "SFProText-Bold", size: 34)
        ?? UIFont.systemFont(ofSize: 34, weight: .bold)

    /// Жирный шрифт `SFProText-Bold`, размер 32pt.
    static let sfProBold32 = UIFont(name: "SFProText-Bold", size: 32)
        ?? UIFont.systemFont(ofSize: 32, weight: .bold)

    /// Жирный шрифт `SFProText-Bold`, размер 28pt.
    static let sfProBold28 = UIFont(name: "SFProText-Bold", size: 28)
        ?? UIFont.systemFont(ofSize: 28, weight: .bold)

    /// Жирный шрифт `SFProText-Bold`, размер 22pt.
    static let sfProBold22 = UIFont(name: "SFProText-Bold", size: 22)
        ?? UIFont.systemFont(ofSize: 22, weight: .bold)

    /// Жирный шрифт `SFProText-Bold`, размер 20pt.
    static let sfProBold20 = UIFont(name: "SFProText-Bold", size: 20)
        ?? UIFont.systemFont(ofSize: 20, weight: .bold)

    /// Жирный шрифт `SFProText-Bold`, размер 17pt.
    static let sfProBold17 = UIFont(name: "SFProText-Bold", size: 17)
        ?? UIFont.systemFont(ofSize: 17, weight: .bold)

    // MARK: - Medium Fonts
    /// Средний шрифт `SFProText-Medium`, размер 10pt.
    static let sfProMedium10 = UIFont(name: "SFProText-Medium", size: 10)
        ?? UIFont.systemFont(ofSize: 10, weight: .medium)
    
    // MARK: - Regular Fonts

    /// Обычный шрифт `SFProText-Regular`, размер 17pt.
    static let sfProRegular17 = UIFont(name: "SFProText-Regular", size: 17)
        ?? UIFont.systemFont(ofSize: 17, weight: .regular)

    /// Обычный шрифт `SFProText-Regular`, размер 15pt.
    static let sfProRegular15 = UIFont(name: "SFProText-Regular", size: 15)
        ?? UIFont.systemFont(ofSize: 15, weight: .regular)

    /// Обычный шрифт `SFProText-Regular`, размер 13pt.
    static let sfProRegular13 = UIFont(name: "SFProText-Regular", size: 13)
        ?? UIFont.systemFont(ofSize: 13, weight: .regular)
}
