//
//  CoreDataMockSetup.swift
//  Djaft
//
//  Created by Jan Nash on 12/19/15.
//  Copyright © 2015 Jan Nash. All rights reserved.
//

import CoreData


// Internal Interface
internal extension CoreDataMockSetup {
    internal class func createObjectContext() -> NSManagedObjectContext {
        return self._createObjectContext()
    }
}


// Main Implementation
internal class CoreDataMockSetup: AnyObject {
    private class func _createObjectContext() -> NSManagedObjectContext {
        let bundle: NSBundle = NSBundle(forClass: self)
        let modelURL = bundle.URLForResource("DjaftUnitTestDataModel", withExtension: "momd")
        let mom = NSManagedObjectModel(contentsOfURL: modelURL!)
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom!)
        
        do {
            try psc.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
        } catch let error as NSError {
            fatalError("Failed setting up Test-database with error \(error)")
        }
        
        let objectContext: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        objectContext.persistentStoreCoordinator = psc
        
        return objectContext
    }
}
