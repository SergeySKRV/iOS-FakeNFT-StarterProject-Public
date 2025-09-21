//
//  ProfilePresenterProtocols.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 04.09.2025.
//

import UIKit

// MARK: - Presenter Output Contract

/// Контракт между Presenter и View.
/// Определяет методы, которые View обязана реализовать для взаимодействия с Presenter.
protocol ProfilePresenterOutput: AnyObject {
    /// Обновить UI данными профиля.
    func updateProfileUI(_ viewModel: UserProfileViewModel)

    /// Открыть WebView с указанным URL.
    func showWebViewController(urlString: String)

    /// Открыть экран редактирования профиля.
    func showEditProfileViewController(with profile: UserProfile)

    /// Показать ошибку (например, при загрузке данных).
    func showError(_ error: Error)

    /// Показать индикатор загрузки.
    func showLoading()

    /// Скрыть индикатор загрузки.
    func hideLoading()
}

// MARK: - Presenter Lifecycle

/// Методы жизненного цикла Presenter.
protocol ProfilePresenterLifecycle {
    /// Вызывается после загрузки View.
    func viewDidLoad()

    /// Вызывается перед появлением View на экране.
    func viewWillAppear()
}

// MARK: - Presenter Actions

/// Методы обработки пользовательских действий.
protocol ProfilePresenterActions {
    /// Открытие сайта пользователя.
    func openWebsite()

    /// Нажатие кнопки "Редактировать профиль".
    func editProfileTapped()

    /// Обновление данных профиля (например, при pull-to-refresh).
    func refreshProfileData()

    /// Обработка обновления профиля (например, после редактирования).
    func handleProfileUpdate(_ profile: UserProfile)
}

// MARK: - Presenter Table View Operations

/// Методы, связанные с работой `UITableView`.
protocol ProfilePresenterTableViewOperations {
    /// Количество строк в секции.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int

    /// Ячейка для строки по `indexPath`.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell

    /// Высота ячейки по `indexPath`.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat

    /// Обработка выбора ячейки.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
}

// MARK: - Main Presenter Protocol

/// Главный протокол Presenter для экрана профиля.
/// Объединяет:
/// - методы жизненного цикла,
/// - обработку действий пользователя,
/// - работу с таблицей.
protocol ProfilePresenterProtocol:
    ProfilePresenterLifecycle,
    ProfilePresenterActions,
    ProfilePresenterTableViewOperations {

    /// Инициализация Presenter.
    /// - Parameters:
    ///   - view: View, реализующая `ProfilePresenterOutput`.
    ///   - userService: Сервис работы с профилем пользователя.
    ///   - servicesAssembly: Ассемблер сервисов для зависимостей.
    init(view: ProfilePresenterOutput, userService: UserProfileService, servicesAssembly: ServicesAssembly)
}
