//
//  Database.swift
//  TuturuTest
//
//  Created by Артем on 21/10/2016.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//
// Вспомогательные методы для работы с базой

import UIKit
import CoreData

class MyDocument: UIManagedDocument {
    
    override class var persistentStoreName : String{
        return "ImageList.sqlite"
    }
    
    override func contents(forType typeName: String) throws -> Any {
        print ("Auto-Saving Document")
        return try! super.contents(forType: typeName)
    }
    
    override func handleError(_ error: Error, userInteractionPermitted: Bool) {
        print("Ошибка при записи:\(error.localizedDescription)")
        if let userInfo = error._userInfo as? [String:AnyObject],
            let conflicts = userInfo["conflictList"] as? NSArray{
            print("Конфликты при записи:\(conflicts)")
            
        }
    }
}

extension NSManagedObjectContext
{
    public func saveThrows () {
        do {
            try save()
        } catch let error  {
            print("Core Data Error: \(error)")
        }
    }
}

extension UIManagedDocument {
    
    class func useDocument (_ completion: @escaping ( _ document: MyDocument) -> Void) {
        let fileManager = FileManager.default
        let doc = "database"
        let urls = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        
        let url = urls[urls.count - 1].appendingPathComponent(doc)
        // print (url)
        let document = MyDocument(fileURL: url)
        document.persistentStoreOptions =
            [ NSMigratePersistentStoresAutomaticallyOption: true,
              NSInferMappingModelAutomaticallyOption: true]
        
        document.managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        if let parentContext = document.managedObjectContext.parent{
            parentContext.perform {
                parentContext.mergePolicy =  NSMergeByPropertyObjectTrumpMergePolicy
            }
        }
        
        if !fileManager.fileExists(atPath: url.path) {
            document.save(to: url, for: .forCreating) { (success) -> Void in
                if success {
                    print("File создан: Success")
                    completion (document)
                }
            }
        }else  {
            if document.documentState == .closed {
                document.open(){(success:Bool) -> Void in
                    if success {
                        print("File существует: Открыт")
                        completion (document)                    
                    }
                }
            } else {
                completion ( document)
            }
        }
        
    }
    
}
