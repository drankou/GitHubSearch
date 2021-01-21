//
//  ImageCache.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 17.01.2021.
//

import UIKit
import Foundation

public class ImageCache {
    
    public static let publicCache = ImageCache()
    var placeholderImage = UIImage(named: "user-default.png")!
    private let cachedImages = NSCache<NSURL, UIImage>()
    private var loadingResponses = [NSURL: [(User, UIImage?) -> Swift.Void]]()
    
    public final func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }

    final func load(url: NSURL, item: User, completion: @escaping (User, UIImage?) -> Swift.Void) {
        if let cachedImage = image(url: url) {
            DispatchQueue.main.async {
                completion(item, cachedImage)
            }
            return
        }
        
        if loadingResponses[url] != nil {
            loadingResponses[url]?.append(completion)
            return
        } else {
            loadingResponses[url] = [completion]
        }
  
       let task = URLSession.shared.dataTask(with: url as URL) { (data, response, error) in
            guard let responseData = data, let image = UIImage(data: responseData),
                  let blocks = self.loadingResponses[url], error == nil else {
                DispatchQueue.main.async {
                    completion(item, nil)
                }
                return
            }

            self.cachedImages.setObject(image, forKey: url, cost: responseData.count)
        
            for block in blocks {
                DispatchQueue.main.async {
                    block(item, image)
                }
                return
            }
        }
        
        task.resume()
    }
}
