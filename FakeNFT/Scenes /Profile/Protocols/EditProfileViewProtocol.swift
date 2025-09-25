//
//  EditProfileViewProtocol.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 04.09.2025.
//

import UIKit

// MARK: - View Contract

/// Контракт для View в модуле редактирования профиля.
/// Определяет все методы, которые View должна реализовать для работы с Presenter.
protocol EditProfilePresenterOutput: AnyObject {
    /// Обновить UI данными профиля.
    func updateProfileUI(_ profile: UserProfile)

    /// Показать алерт подтверждения выхода без сохранения.
    func showExitConfirmationAlert()

    /// Показать алерт с вариантами выбора фото (камера / галерея / URL).
    func showPhotoOptionsAlert()

    /// Показать алерт для ввода URL аватара.
    func showPhotoURLAlert()

    /// Отобразить индикатор загрузки.
    func showLoader()

    /// Скрыть индикатор загрузки.
    func hideLoader()

    /// Закрыть экран редактирования.
    func dismissViewController()

    /// Показать универсальный алерт.
    func showAlert(title: String, message: String?)

    /// Загрузить изображение по URL.
    func loadImageFromURL(_ url: URL, completion: @escaping (UIImage?) -> Void)

    /// Обновить аватар в интерфейсе.
    func updateProfileImage(_ image: UIImage)

    /// Сохранить профиль локально (в `UserDefaults` или БД).
    func saveUserProfileLocally(_ profile: UserProfile)

    /// Обновить профиль на сервере.
    func updateUserProfile(_ profile: UserProfile, completion: @escaping (Result<Bool, Error>) -> Void)

    /// Настроить элементы навигации (например, кнопки).
    func setupNavigationBar()

    /// Начать отслеживание изменений в текстовых полях.
    func observeTextFieldsForChanges()

    /// Получить текущее изображение профиля.
    func getProfileImage() -> UIImage?

    /// Получить введённое имя.
    func getNameText() -> String?

    /// Получить введённое описание.
    func getDescriptionText() -> String?

    /// Получить введённый сайт.
    func getWebsiteText() -> String?

    /// Установить флаг наличия изменений.
    func setHasChanges(_ hasChanges: Bool)

    /// Проверить, есть ли несохранённые изменения.
    func getHasChanges() -> Bool

    /// Получить строку с URL аватара (если задан).
    func getAvatarURLString() -> String?
}

// MARK: - Presenter Lifecycle

/// Жизненный цикл Presenter'а.
protocol EditProfilePresenterLifecycle {
    /// Вызывается при загрузке View.
    func viewDidLoad()

    /// Вызывается при появлении View.
    func viewWillAppear()

    /// Вызывается при скрытии View.
    func viewWillDisappear()
}

// MARK: - Presenter Actions

/// Действия пользователя, обрабатываемые Presenter'ом.
protocol EditProfilePresenterActions {
    /// Нажатие на кнопку "Назад".
    func backButtonTapped()

    /// Нажатие на кнопку "Сохранить".
    func saveButtonTapped()

    /// Нажатие на кнопку камеры.
    func cameraButtonTapped()

    /// Изменение содержимого полей.
    func contentChanged()

    /// Удаление фотографии профиля.
    func photoDeleted()

    /// Изменение фото через URL.
    func photoURLChanged(_ url: URL)
}

// MARK: - Presenter UI Operations

/// Методы для управления UI из Presenter'а.
protocol EditProfilePresenterUIOperations {
    func showExitConfirmationAlert()
    func showPhotoOptionsAlert()
    func showPhotoURLAlert()
    func showLoader()
    func hideLoader()
    func dismissViewController()
    func showAlert(title: String, message: String?)
    func updateProfileImage(_ image: UIImage)
    func setupNavigationBar()
    func observeTextFieldsForChanges()
}

// MARK: - Presenter Data Operations

/// Методы для работы с данными профиля.
protocol EditProfilePresenterDataOperations {
    func loadImageFromURL(_ url: URL, completion: @escaping (UIImage?) -> Void)
    func saveUserProfileLocally(_ profile: UserProfile)
    func updateUserProfile(_ profile: UserProfile, completion: @escaping (Result<Bool, Error>) -> Void)
}

// MARK: - Main Presenter Protocol

/// Главный протокол Presenter'а, объединяющий все обязанности:
/// - управление жизненным циклом,
/// - обработка действий пользователя,
/// - работа с UI,
/// - работа с данными.
protocol EditProfilePresenterProtocol:
    EditProfilePresenterLifecycle,
    EditProfilePresenterActions,
    EditProfilePresenterUIOperations,
    EditProfilePresenterDataOperations {

    /// Инициализатор Presenter'а.
    /// - Parameters:
    ///   - view: View, реализующая `EditProfilePresenterOutput`.
    ///   - userProfile: Текущий профиль пользователя.
    ///   - userService: Сервис для работы с профилем.
    ///   - imageLoaderService: Сервис для загрузки изображений.
    init(
        view: EditProfilePresenterOutput,
        userProfile: UserProfile,
        userService: UserProfileService,
        imageLoaderService: ProfileImageLoaderService
    )
}
