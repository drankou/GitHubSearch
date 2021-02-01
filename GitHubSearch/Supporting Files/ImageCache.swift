//
//  ImageCache.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 17.01.2021.
//

import UIKit
import Alamofire
import AlamofireImage
import PromiseKit
import Foundation

public class ImageCache {
    public static let publicCache = ImageCache()

    var placeholderImage = UIImage(named: "user-default.png")!
    let imageCache = AutoPurgingImageCache(
        memoryCapacity: 100_000_000,
        preferredMemoryUsageAfterPurge: 60_000_000
    )
    
    private var loadingResponses = [URL: Promise<UIImage>]()

    func getImage(_ url: URL) -> Promise<UIImage> {
        if let pendingPromise = loadingResponses[url] {
            return pendingPromise
        }
        
        let promise = Promise<UIImage> {seal in
            if let cachedImage = cachedImage(for: url) {
                seal.fulfill(cachedImage)
            }
            
            AF.request(url)
                .validate()
                .responseImage { (response) in
                    switch response.result {
                    case.success(let image):
                        seal.fulfill(image)
                        self.imageCache.add(image, for: URLRequest(url: url, cachePolicy: .returnCacheDataDontLoad))
                    case.failure(let error):
                        seal.reject(error)
                    }
                }
        }
        
        loadingResponses[url] = promise
        return promise
    }
    
    func cachedImage(for url: URL) -> UIImage?{
        self.imageCache.image(for: URLRequest(url: url))
    }
}
