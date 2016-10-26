//
//  ImageListTableViewController.swift
//  RosEvroBankTest
//
//  Created by Артем on 25/10/2016.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import UIKit
import CoreData

class PhotoListTableViewController: CoreDataTableViewController {
    
    var cache = NSCache<AnyObject, AnyObject>()
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath)
        if let cell = cell as? PhotoViewCell,
         let photo = fetchedResultsController?.object(at: indexPath) as? Photo {
            cell.cache = cache
            cell.photo = photo
        }
        return cell
    }

}
