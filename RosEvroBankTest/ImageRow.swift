//
//  ImageRow.swift
//  RosEvroBankTest
//
//  Created by Артем on 25/10/2016.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import Foundation

class ImageRow {
    
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
    
    init(data: AnyObject) {
        if let data = data as? [String:AnyObject] {
            let albumId = data["albumId"] as? Int
            let id = data["id"] as? Int
            let title = data["title"] as? String
            let url = data["url"] as? String
            let thumbnailUrl = data["thumbnailUrl"] as? String
            
            self.albumId = albumId!
            self.id = id!
            self.title = title!
            self.url = url!
            self.thumbnailUrl = thumbnailUrl!
            
        } else {
            print("все пошло по звезде!")
            
            self.albumId = -1
            self.id = -1
            self.title = ""
            self.url = ""
            self.thumbnailUrl = ""

        }
    }
}
