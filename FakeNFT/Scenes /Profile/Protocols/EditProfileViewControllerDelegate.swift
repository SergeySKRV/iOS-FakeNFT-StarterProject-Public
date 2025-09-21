//
//  EditProfileViewControllerDelegate.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 11.09.2025.
//

import Foundation

// MARK: - EditProfileViewControllerDelegate

/// Делегат для экрана редактирования профиля.
///
/// Используется для передачи событий из `EditProfileViewController`
/// обратно к вызывающему объекту (например, Presenter или Coordinator).
protocol EditProfileViewControllerDelegate: AnyObject {
    // Здесь будут методы делегата, например:
    // func didUpdateProfile(_ profile: UserProfile)
    // func didCancelEditing()
}
