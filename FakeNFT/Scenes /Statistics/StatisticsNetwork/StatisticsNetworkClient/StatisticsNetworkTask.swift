import Foundation

protocol StatisticsNetworkTask {
    func cancel()
}

struct StatisticsDefaultNetworkTask: StatisticsNetworkTask {
    let dataTask: URLSessionDataTask

    func cancel() {
        dataTask.cancel()
    }
}
