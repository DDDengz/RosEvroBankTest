//
//  ImageViewCell.swift
//  RosEvroBankTest
//
//  Created by Артем on 25/10/2016.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import UIKit

class PhotoViewCell: UITableViewCell {
    
    // MARK: Model
    
    var photo: Photo? {
        didSet {
            updateUI()
        }
    }
    
    var cache: NSCache<AnyObject, AnyObject>?
    
    private var lastUrl: URL?
    
    var dataTask: URLSessionDataTask?
    
    // MARK: Outlets

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var photoTitle: UILabel!
    
    func updateUI() {
        // переустанавливаем информацию существующей строки
        photoView.image = nil
        photoTitle.text = nil
        
        // Загружаем новую информацию, если она определена
        if let photo = self.photo {
            photoTitle.text = photo.title
            fetchImage(photo)
        }
    }
    
    func fetchImage(_ imageR: Photo) {
        if let thumbailUrl = photo?.thumbailUrl {
            
            if dataTask != nil {
                dataTask?.cancel()
            }
            
            let imageData = cache?.object(forKey: thumbailUrl as AnyObject) as? Data
            guard imageData == nil else { photoView.image = UIImage(data: imageData!); return }
            
            let urlRequest = URLRequest(
                url: thumbailUrl,
                cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                timeoutInterval: 10.0 * 1000)
            
            let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
            
            dataTask = defaultSession.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                } else if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        DispatchQueue.main.async {
                            self.photoView.image = UIImage(data: data!)
                            self.cache?.setObject(data as AnyObject, forKey: thumbailUrl as AnyObject,
                                                                              cost: (data?.count)! )
                        }
                    }
                }
            })
            
            dataTask?.resume()
            
        }
    }
    
}
