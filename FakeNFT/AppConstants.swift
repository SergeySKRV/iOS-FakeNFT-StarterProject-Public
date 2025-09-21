//
//  AppConstants.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 16.09.2025.
//

import Foundation

// MARK: - App Constants
enum AppConstants {

    // MARK: - User Defaults Keys
    enum UserDefaultsKeys {
        static let hasSeenOnboarding = "hasSeenOnboarding"
    }

    // MARK: - Onboarding
    enum Onboarding {
        static let autoScrollInterval: TimeInterval = 5.0
        static let slideCount = 3
    }
}
