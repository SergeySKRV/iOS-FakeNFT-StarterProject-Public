import Foundation
import UIKit

final class StatisticsViewPresenter {
    static let shared = StatisticsViewPresenter()
    
    private let mockProfile = StatisticsProfileModel(avatarImage: UIImage(named: "Avatar") ?? UIImage(),
                                                     name: "Joaquin Phoenix",
                                                     nftCount: 123)
    var statisticsViewModel: [StatisticsProfileModel] = []
    
    init() {
        for _ in 1...10 {
            self.statisticsViewModel.append(mockProfile)
        }
        let storage = UsersStorageImpl()
        let networkClient = DefaultNetworkClient()
        let service = UsersServiceImpl(networkClient: networkClient, storage: storage)
        let result = service.loadUsers() { result in
            switch result {
            case .success(let users):
                for user in users {
                    print("User name: \(user) \n")
                   
                          
                }
            case .failure(let error):
                print("error in SVP \(error)")
            }
        }
       
    }
}
