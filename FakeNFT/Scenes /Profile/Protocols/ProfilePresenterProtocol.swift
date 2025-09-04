//
//  ProfilePresenterProtocols.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 04.09.2025.
//

import UIKit

// MARK: - Presenter Output Contract
protocol ProfilePresenterOutput: AnyObject {
    func updateProfileUI(_ profile: UserProfile)
    func showWebViewController(urlString: String)
    func showEditProfileViewController(with profile: UserProfile)
    func showError(_ error: Error)
}

// MARK: - Presenter Lifecycle
protocol ProfilePresenterLifecycle {
    func viewDidLoad()
    func viewWillAppear()
}

// MARK: - Presenter Actions
protocol ProfilePresenterActions {
    func openWebsite()
    func editProfileTapped()
    func refreshProfileData()
    func handleProfileUpdate(_ profile: UserProfile)
}

// MARK: - Presenter Table View Operations
protocol ProfilePresenterTableViewOperations {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
}

// MARK: - Main Presenter Protocol
protocol ProfilePresenterProtocol:
    ProfilePresenterLifecycle,
    ProfilePresenterActions,
    ProfilePresenterTableViewOperations {
    
    init(view: ProfilePresenterOutput, userService: UserProfileService)
}
