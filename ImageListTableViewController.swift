//
//  ImageListTableViewController.swift
//  RosEvroBankTest
//
//  Created by Артем on 25/10/2016.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import UIKit
import CoreData

class ImageListTableViewController: CoreDataTableViewController {
    
    var client = HTTPClient()
    
    // MARK: Model
    var moc: NSManagedObjectContext? {
        didSet {
            print("Controller moc \(moc.debugDescription)")
            print("Controller moc.parent \(moc?.parent.debugDescription)")
            client.fetchData(moc: moc!)
            updateUI()
        }
    }
    var resultsController: NSFetchedResultsController<Image>!
    var cache = NSCache<AnyObject, AnyObject>()
    
    func updateUI() {
        if let context = moc {
            let request = NSFetchRequest<Image>(entityName: "Image")
                request.predicate = NSPredicate(format: "TRUEPREDICATE")

            request.sortDescriptors = [NSSortDescriptor(
                key: "albumUnique",
                ascending: true
                ), NSSortDescriptor(
                    key: "unique",
                    ascending: true
                )]
            resultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: "albumUnique",
                cacheName: nil
            )
            fetchedResultsController =  resultsController as? NSFetchedResultsController<NSFetchRequestResult>? ?? nil
        } else {
            fetchedResultsController = nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if moc == nil {
            UIManagedDocument.useDocument({ (document) in
                self.moc = document.managedObjectContext
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath)
        if let cell = cell as? ImageViewCell,
         let image = fetchedResultsController?.object(at: indexPath) as? Image {
            cell.cache = cache
            cell.imageT = image
        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
