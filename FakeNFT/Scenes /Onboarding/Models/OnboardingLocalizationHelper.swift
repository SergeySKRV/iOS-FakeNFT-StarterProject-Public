//
//  OnboardingLocalizationHelper.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 16.09.2025.
//

import Foundation

// MARK: - Onboarding Localization Helper
enum OnboardingLocalizationHelper {

    // MARK: - Static Methods
    static func localizedTitle(for slideIndex: Int) -> String {
        let key = "Onboarding.slide\(slideIndex + 1).title"
        return NSLocalizedString(key, comment: "Slide \(slideIndex + 1) title")
    }

    static func localizedSubtitle(for slideIndex: Int) -> String {
        let key = "Onboarding.slide\(slideIndex + 1).subtitle"
        return NSLocalizedString(key, comment: "Slide \(slideIndex + 1) subtitle")
    }

    static func nextButtonTitle() -> String {
        NSLocalizedString("Onboarding.nextButton", comment: "Next button title")
    }
}
