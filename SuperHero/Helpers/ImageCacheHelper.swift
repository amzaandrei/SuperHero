//
//  ImageCacheHelper.swift
//  SuperHero
//
//  Created by Andrei on 14.02.23.
// 
import UIKit

let imageCache = NSCache<NSString, UIImage>()

class ImageCache {
    
    static let sharedInstance = ImageCache()
    
    @objc func loadImageUsingCacheString(urlString: String) -> UIImage {
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            return cachedImage
        }
        
        let url = URL(string: urlString)
        let group = DispatchGroup()
        var finalImage: UIImage!
        group.enter()
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            
            if let downloadedImage = UIImage(data: data!){
                imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                finalImage = downloadedImage
                group.leave()
            }
            
        }).resume()
        group.wait()
        return finalImage
    }
}
