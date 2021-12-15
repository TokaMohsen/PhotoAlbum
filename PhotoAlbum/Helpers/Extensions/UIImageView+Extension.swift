//
//  UIImageView+Extension.swift
//  PhotoAlbum
//
//  Created by toka mohsen on 09/12/2021.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func downloadImage(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) {
                 self.image = imageFromCache as? UIImage
                 return
             }
             
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
                imageCache.setObject(image, forKey: url as AnyObject)
            }
        }.resume()
    }
    
    func downloadImage(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadImage(from: url, contentMode: mode)
    }
}
