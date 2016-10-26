//
//  Photo+CoreDataProperties.swift
//  RosEvroBankTest
//
//  Created by Артем on 25/10/2016.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }

    @NSManaged public var unique: Int32
    @NSManaged public var albumUnique: Int32
    @NSManaged public var title: String
    @NSManaged public var imageUrlString: String
    @NSManaged public var thumbaiUrlString: String
    
    var imageUrl: URL? {
        get {
            return URL(string: self.imageUrlString)
        }
        set {
            self.imageUrlString = newValue?.absoluteString ?? ""
        }
    }
    
    var thumbailUrl: URL? {
        get {
            return URL(string: self.thumbaiUrlString)
        }
        set {
            self.thumbaiUrlString = newValue?.absoluteString ?? ""
        }
    }

}
