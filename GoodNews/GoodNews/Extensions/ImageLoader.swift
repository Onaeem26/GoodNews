//
//  ImageLoader.swift
//  GoodNews
//
//  Created by Muhammad Osama Naeem on 5/4/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.
//

import UIKit

class ImageLoader {
    private var loadedImages = [URL: UIImage]()
    private var runningRequests = [UUID : URLSessionTask]()
    
    init() {}
    
    func loadImage(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        
        if let image = loadedImages[url] {
            completion(.success(image))
            return nil
        }
        
        let uuid = UUID()
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            defer {self.runningRequests.removeValue(forKey: uuid) }
            
            if let data = data, let image = UIImage(data: data) {
                self.loadedImages[url] = image
                completion(.success(image))
            }
            
            guard let error = error else {
                print("Difficulty in loading picture")
                return
            }
            
            guard (error as NSError).code == NSURLErrorCancelled else {
                print("Error")
                completion(.failure(error))
                return
            }

        }
        
        task.resume()
        
        runningRequests[uuid] = task
        return uuid
    }
    
    func cancelLoad(_ uuid: UUID) {
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
}
