import UIKit

protocol ImageLoaderServiceProtocol {
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) -> UUID?
    func cancelLoad(taskId: UUID)
}

final class ImageLoaderService: ImageLoaderServiceProtocol {
    static let shared = ImageLoaderService()
    private let cache = NSCache<NSString, UIImage>()
    private var runningTasks: [UUID: URLSessionDataTask] = [:]
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) -> UUID? {
        let taskId = UUID()
        
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return nil
        }
        
        guard let url = URL(string: urlString) else {
            completion(UIImage(systemName: "photo"))
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            self?.runningTasks.removeValue(forKey: taskId)
            
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(UIImage(systemName: "photo"))
                }
                return
            }
            
            self?.cache.setObject(image, forKey: urlString as NSString)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        runningTasks[taskId] = task
        task.resume()
        return taskId
    }
    
    func cancelLoad(taskId: UUID) {
        runningTasks[taskId]?.cancel()
        runningTasks.removeValue(forKey: taskId)
    }
}
