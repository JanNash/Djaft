//
//  CoreDataMockSetup.swift
//  Swango
//
//  Created by Jan Nash on 12/19/15.
//  Copyright © 2015 Jan Nash. All rights reserved.
//

import Foundation
import CoreData


// Public Interface
extension CoreDataMockSetup {
    // Variable Class Properties
    class func mainObjectContext() -> NSManagedObjectContext {return self._mainObjectContext}
}


// Main Implementation
class CoreDataMockSetup: AnyObject {
    private static var __mainObjectContext: NSManagedObjectContext!
    private static var _mainObjectContext: NSManagedObjectContext {
        if self.__mainObjectContext == nil {
            self._createMainMOC()
        }
     return self.__mainObjectContext
    }
    
    private class func _createMainMOC() {
        let bundle: NSBundle = NSBundle(forClass: self)
        let modelURL = bundle.URLForResource("SwangoUnitTestDataModel", withExtension: "momd")
        let mom = NSManagedObjectModel(contentsOfURL: modelURL!)
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom!)
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let storeURL = urls.last?.URLByAppendingPathComponent("SwangoUnitTestDB.sqlite")
        
        do {
            try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
        } catch let error as NSError {
            fatalError("Failed setting up Database with error \(error)")
        }
        
        self.__mainObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        self.__mainObjectContext!.persistentStoreCoordinator = psc
        print("Successfully set up Swango unit-test database")
    }
}
