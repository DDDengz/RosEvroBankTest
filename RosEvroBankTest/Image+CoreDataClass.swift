//
//  Image+CoreDataClass.swift
//  RosEvroBankTest
//
//  Created by Артем on 25/10/2016.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import Foundation
import CoreData


public class Image: NSManagedObject {
    
    class func new(_ imageRow: ImageRow, withManagedObjectContext context: NSManagedObjectContext) -> Image? {
        // Создает новую картинку
        let request = NSFetchRequest<Image>(entityName: "Image")
        request.predicate = NSPredicate(format: "unique = %ld", Int32(imageRow.id))
        
        if let image = (try? context.fetch(request))?.first {
            //Если запись есть то ничего не делаем, просто возвращаем запись
            return image
        } else if let image = NSEntityDescription.insertNewObject(forEntityName: "Image",
                                                                  into: context) as? Image {
            image.unique = Int32(imageRow.id)
            image.albumUnique = Int32(imageRow.albumId)
            image.title = imageRow.title
            image.url = imageRow.url
            image.thumbnaiUrl = imageRow.thumbnailUrl
            
            return image
        }
        return nil
    }

}
