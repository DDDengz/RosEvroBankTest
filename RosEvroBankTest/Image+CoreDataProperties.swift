//
//  Image+CoreDataProperties.swift
//  RosEvroBankTest
//
//  Created by Артем on 25/10/2016.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image");
    }

    @NSManaged public var unique: Int32
    @NSManaged public var albumUnique: Int32
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var thumbnaiUrl: String?

}
