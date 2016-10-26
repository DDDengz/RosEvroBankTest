//
//  FetchedPhotoTableViewController.swift
//  RosEvroBankTest
//
//  Created by Артем on 25/10/2016.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import UIKit
import CoreData

class FetchedPhotoTableViewController: PhotoListTableViewController {
    
    private let url = "https://jsonplaceholder.typicode.com/photos"
    
    var coreDataStack: CoreDataStack! {
        didSet {
            self.moc = coreDataStack.mainMoc
            fetchPhotos()
        }
    }
    
    var moc: NSManagedObjectContext? //= (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.mainMoc
    
    var resultController: NSFetchedResultsController<Photo>!
    
    // создание work MOC
    lazy var workMoc: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        moc.parent = self.moc
        moc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return moc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataStack = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack
        if let context = self.moc {
            self.setupFetchedResultsController(context)
        }
    }
    
    func setupFetchedResultsController(_ context: NSManagedObjectContext) {
        
        let request = NSFetchRequest<Photo>(entityName: "Photo")
        request.predicate = NSPredicate(format: "TRUEPREDICATE")
        request.sortDescriptors = [NSSortDescriptor(key: "albumUnique", ascending: true),
                                    NSSortDescriptor(key: "unique", ascending: true)]
        
        resultController = NSFetchedResultsController(fetchRequest: request,
                                                      managedObjectContext: context,
                                                      sectionNameKeyPath: "albumUnique",
                                                      cacheName: nil)
        
        fetchedResultsController = resultController as? NSFetchedResultsController<NSFetchRequestResult> ?? nil
    }
    
    func fetchPhotos() {
        if let url = URL(string: url) {
            
            let task = URLSession.shared.downloadTask(with: url, completionHandler: { (localUrl, response, error) in
                guard error == nil else { return }
                
                // Получаем данные в виде массива словарей
                guard let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200,
                    let url = localUrl,
                    let data = try? Data(contentsOf: url),
                    let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                    let photos = json as? [[String: AnyObject]]
                    else { return }
                
                for photo in photos { // если записывать все сразу то это занимает много времени
                    // и при первом запуске приходится ждать пока на экране что лио появится
                    
                    self.workMoc.perform(){
                        _ = Photo.newPhoto([photo], context: self.workMoc)
                    }
                    self.workMoc.performAndWait(){
                        do {
                            try self.workMoc.save()
                        } catch {
                            fatalError("Ошибка записи данных \(error)")
                        }
                        self.coreDataStack.saveMainContext()
                    }
                    
                }
            })
            
            task.resume()
        }
    }
    

}
