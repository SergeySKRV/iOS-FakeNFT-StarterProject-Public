//
//  ReviewManager.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 20.09.2025.
//

import StoreKit
import UIKit

enum ReviewManager {
    private static let launchesKey = "appLaunchesCount"

    /// Увеличивает счётчик запусков и при необходимости показывает запрос на оценку.
    static func incrementLaunchCountAndAskIfNeeded() {
        let defaults = UserDefaults.standard
        let launches = defaults.integer(forKey: launchesKey) + 1
        defaults.set(launches, forKey: launchesKey)

        // Покажем алерт на 5-м запуске и далее каждые 10 запусков
        if launches == 5 || launches % 10 == 0 {
            requestReview()
        }
    }

    /// Запрашивает у пользователя оценку приложения.
    private static func requestReview() {
        guard let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
            return
        }
        SKStoreReviewController.requestReview(in: scene)
    }
}
