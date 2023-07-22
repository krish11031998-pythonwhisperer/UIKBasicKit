//
//  ImageDownloadManager.swift
//  Pods-UIKBasicKit_Example
//
//  Created by Krishna Venkatramani on 22/07/2023.
//

import Foundation

enum ImageError: Swift.Error {
    case noImagefromData
    case invalidURL
}


protocol ImageCacheSubscript {
    subscript(request: URLRequest) -> UIImage? { get set }
    subscript(urlStr: String) -> UIImage? { get set }
}

typealias ImageDownloadResult = (Result<UIImage, Error>) -> Void

class ImageDownloadTask {
    let downloadTask: URLSessionDataTask
    private var results: [ImageDownloadResult] = []
    
    init(downloadTask: URLSessionDataTask) {
        self.downloadTask = downloadTask
    }
    
    func addResult(result: ImageDownloadResult?) {
        guard let result else { return }
        self.results.append(result)
    }
    
    func sendResult(_ result: Result<UIImage, Error>) {
        results.forEach { $0(result) }
    }
}

//MARK: - ImageCache
class ImageDownloadManager {
    
    
    let dataCache: NSCache<NSURLRequest, UIImage> = {
        let cache = NSCache<NSURLRequest, UIImage>()
        cache.totalCostLimit = 200_000_000
        return cache
    }()
    
    var resultCache: [URLRequest:[ImageDownloadResult]] = [:]
    
    let downloadResultCache: NSCache<NSURLRequest, ImageDownloadTask> = { .init() }()
    
    static var shared: ImageDownloadManager = .init()
    
}

//MARK: - ImageCache + requests
extension ImageDownloadManager {
    
    func loadImage(source: ImageSource, completion: ImageDownloadResult?) {
        switch source {
        case .remote(let url):
            loadImage(urlStr: url, completion: completion)
        default:
            break
        }
    }
    
    func loadImage(urlStr: String, completion: ImageDownloadResult?) {
        guard let url = URL(string: urlStr) else {
            completion?(.failure(ImageError.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        
        if let cachedImage = self[request] {
            completion?(.success(cachedImage))
            return
        }
        
        guard addResultForURLRequest(request: request, result: completion) else { return }
        
        
        let downloadTask = URLSession.shared.dataTask(with: request) { [weak self] data, resp, err in
            
            guard let self else { return }
            
            guard let validData = data else {
                print("(ERROR) Downloading Image: \(err?.localizedDescription ?? "No Error Message")")
                self.fetchDownloadTask(for: request)?.sendResult(.failure(ImageError.noImagefromData))
                self.clearResultCache(request: request)
                //completion?(.failure(ImageError.noImagefromData))
                return
            }
            
            guard let img = UIImage(data: validData) else {
                print("(ERROR) Downloading Image: \("Cannot convert data to UIImage")")
                self.fetchDownloadTask(for: request)?.sendResult(.failure(ImageError.noImagefromData))
                self.clearResultCache(request: request)
                return
            }
            
            
            self[request] = img
            
            self.fetchDownloadTask(for: request)?.sendResult(.success(img))
            self.clearResultCache(request: request)
        }
        
        addResultAndTaskForURLRequest(task: downloadTask, request: request, result: completion)
        
        downloadTask.resume()
    }
    
    private func addResultForURLRequest(request: URLRequest,
                                        result: ImageDownloadResult?) -> Bool
    {
        let nsRequest = request as NSURLRequest
        if let downloadResult = downloadResultCache.object(forKey: nsRequest) {
            downloadResult.addResult(result: result)
            return false
        }
        return true
    }
    
    private func addResultAndTaskForURLRequest(task: URLSessionDataTask,
                                        request: URLRequest,
                                        result: ImageDownloadResult?)
    {
        let nsRequest = request as NSURLRequest
        let task = ImageDownloadTask(downloadTask: task)
        task.addResult(result: result)
        downloadResultCache.setObject(task, forKey: nsRequest)
    }
    
    private func fetchDownloadTask(for request: URLRequest) -> ImageDownloadTask? {
        let nsRequest = request as NSURLRequest
        guard let downloadTask = downloadResultCache.object(forKey: nsRequest) else { return nil }
        return downloadTask
    }
    
    private func clearResultCache(request: URLRequest) {
        downloadResultCache.removeObject(forKey: request as NSURLRequest)
    }
    
    func cancelDownloadTask(for source: ImageSource) {
        switch source {
        case .remote(let url):
            cancelDownloadTask(for: url)
        default:
            break
        }
    }
    
    func cancelDownloadTask(for urlStr: String) {
        guard let url = URL(string: urlStr) else { return }
        let request = URLRequest(url: url) as NSURLRequest
        if let downloadResult = downloadResultCache.object(forKey: request)?.downloadTask {
            downloadResult.cancel()
        }
    }
}

//MARK: - ImageCache + ImageCacheSubscript
extension ImageDownloadManager: ImageCacheSubscript {
    
    subscript(request: URLRequest) -> UIImage? {
        get {
            guard let image = dataCache.object(forKey: request as NSURLRequest) else { return nil }
            return image
        }
        set {
            let nsReq = request as NSURLRequest
            if let _ = dataCache.object(forKey: nsReq) {
                dataCache.removeObject(forKey: nsReq)
            }
            
            if let validImage = newValue {
                dataCache.setObject(validImage, forKey: nsReq)
            }
        }
    }
    
    
    subscript(urlStr: String) -> UIImage? {
        get {
            guard let url = URL(string: urlStr) else { return nil }
            return self[URLRequest(url: url)]
        }
        set {
            guard let url = URL(string: urlStr) else { return }
            self[URLRequest(url: url)] = newValue
        }
    }
    
    
    
}
