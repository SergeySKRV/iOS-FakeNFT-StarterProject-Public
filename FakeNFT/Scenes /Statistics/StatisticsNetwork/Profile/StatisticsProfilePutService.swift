import Foundation

typealias StatisticsProfilePutCompletion = (Result<StatisticsProfile, Error>) -> Void

protocol StatisticsProfilePutService {
    func sendStatisticsProfilePutRequest(
        param1: String,
        param2: String,
        completion: @escaping StatisticsProfilePutCompletion
    )
}
/*
final class StatisticsProfilePutServiceImpl: StatisticsProfilePutService {
  
    private let networkClient: NetworkClient
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    func sendStatisticsProfilePutRequest(
        param1: String,
        param2: String,
        completion: @escaping StatisticsProfilePutCompletion
    ) {
       // let dto = StatisticsProfileDtoObject(param1: param1, param2: param2)
        //let request = StatisticsProfilePutRequest(dto: dto)
        networkClient.send(request: request, type: StatisticsProfilePutResponse.self) { result in
            switch result {
            case .success(let putResponse):
                completion(.success(putResponse))
                print(putResponse)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
 */
