//
//  OnboardingLocalizationHelper.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 16.09.2025.
//

import Foundation

// MARK: - OnboardingLocalizationHelper

/// Вспомогательный enum для локализации текста онбординга.
///
/// Содержит методы для получения локализованных строк
/// (заголовки и подзаголовки слайдов, кнопка «Далее»).
enum OnboardingLocalizationHelper {

    // MARK: - Static Methods

    /// Возвращает локализованный заголовок для слайда по индексу.
    ///
    /// Ключ формируется как:
    /// - `"Onboarding.slide{index+1}.title"`
    ///
    /// Пример: для `slideIndex = 0` → `"Onboarding.slide1.title"`
    ///
    /// - Parameter slideIndex: Индекс слайда (начиная с 0).
    /// - Returns: Локализованная строка.
    static func localizedTitle(for slideIndex: Int) -> String {
        let key = "Onboarding.slide\(slideIndex + 1).title"
        return NSLocalizedString(key, comment: "Slide \(slideIndex + 1) title")
    }

    /// Возвращает локализованный подзаголовок для слайда по индексу.
    ///
    /// Ключ формируется как:
    /// - `"Onboarding.slide{index+1}.subtitle"`
    ///
    /// Пример: для `slideIndex = 0` → `"Onboarding.slide1.subtitle"`
    ///
    /// - Parameter slideIndex: Индекс слайда (начиная с 0).
    /// - Returns: Локализованная строка.
    static func localizedSubtitle(for slideIndex: Int) -> String {
        let key = "Onboarding.slide\(slideIndex + 1).subtitle"
        return NSLocalizedString(key, comment: "Slide \(slideIndex + 1) subtitle")
    }

    /// Возвращает локализованное название кнопки «Далее».
    ///
    /// Ключ: `"Onboarding.nextButton"`
    static func nextButtonTitle() -> String {
        NSLocalizedString("Onboarding.nextButton", comment: "Next button title")
    }
}
