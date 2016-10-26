import Foundation
import CoreData

class CoreDataStack: NSObject {
    static let moduleName = "Model"
    
    func saveMainContext() {
        guard mainMoc.hasChanges || privateMoc.hasChanges else {
            return
        }
        
        mainMoc.performAndWait() {
            do {
                //let startTime = CFAbsoluteTimeGetCurrent()
                try self.mainMoc.save()
                //let endTime = CFAbsoluteTimeGetCurrent()
                //let elapsedTime = (endTime - startTime) * 1000
                //print("Pushing main context took \(elapsedTime) ms")
                
            } catch {
                fatalError("Ошибка сохранения mainMoc! \(error)")
            }
        }
        
        privateMoc.perform() {
            do {
                //let startTime1 = CFAbsoluteTimeGetCurrent()
                try self.privateMoc.save()
                //let endTime1 = CFAbsoluteTimeGetCurrent()
                //let elapsedTime1 = (endTime1 - startTime1) * 1000
                //print("Saving private context took \(elapsedTime1) ms")
            } catch {
                fatalError("Ошибка сохранения privateMoc! \(error)")
            }
        }
        
    }
    
    lazy var model: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: moduleName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var directory: URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }()
    
    lazy var coordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.model)
        
        let persistentStoreURL = self.directory.appendingPathComponent("\(moduleName).sqlite")
        print (persistentStoreURL)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: persistentStoreURL,
                                               options: [NSMigratePersistentStoresAutomaticallyOption: true,
                                                         NSInferMappingModelAutomaticallyOption: false])
        } catch {
            fatalError("Persistent store error! \(error)")
        }
        
        return coordinator
    }()
    
    // создание writer MOC
    fileprivate lazy var privateMoc: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        moc.persistentStoreCoordinator = self.coordinator
        
        moc.mergePolicy =  NSMergeByPropertyObjectTrumpMergePolicy
        
        return moc
    }()
    
    // создание main thread MOC
    lazy var mainMoc: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        moc.parent = self.privateMoc
        
        moc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return moc
    }()
    
}
