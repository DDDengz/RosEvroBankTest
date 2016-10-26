//
//  Photo+CoreDataClass.swift
//  RosEvroBankTest
//
//  Created by Артем on 25/10/2016.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import Foundation
import CoreData
import UIKit


public class Photo: NSManagedObject {
    
    convenience init?(json: [String: AnyObject], context: NSManagedObjectContext) {
        
        guard let title = json["title"] as? String,
            let imageUrlString = json["url"] as? String,
            let thumbaiUrlString = json["thumbnailUrl"] as? String,
            let unique = json["id"] as? Int,
            let albumUnique = json["albumId"] as? Int
            else { return nil }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Photo",
                                                      in: context)
            else { return nil }
        
        self.init(entity: entity, insertInto: context)
        
        self.unique = Int32(unique)
        self.albumUnique = Int32(albumUnique)
        self.title = title
        self.imageUrlString = imageUrlString
        self.thumbaiUrlString = thumbaiUrlString
    }
    
    static func newPhoto(_ json: [[String: AnyObject]], context: NSManagedObjectContext) -> [Photo] {
        var photos = [Photo]()
        var uniques = [Int]()
        let fetchRequest = NSFetchRequest<Photo>(entityName: "Photo")
        do {
            if let results = try context.fetch(fetchRequest) as? [Photo] {
                uniques = results.flatMap({Int($0.unique)}).sorted()
                //print(uniques.count)
            }
        } catch {
            fatalError("Ошибка при выборке списка")
        }
        
        let uniquesFetched = json.flatMap({$0["id"] as? Int}).sorted()
        let uniquesSet = Set(uniques)
        var newUniques = Set(uniquesFetched)
        newUniques.subtract(uniquesSet)
        // print("Кол-во новых элементов = \(newUniques.count)")
        
        for unic in newUniques {
            if let index = json.index(where: {$0["id"] as? Int == unic}){
                let photo =  Photo.init(json: json[index], context: context)
                photos.append(photo!)
            }
        }
        return photos
    }

}
