//
//  SWObjectManager.swift
//  Swango
//
//  Created by Jan Nash on 16/11/15.
//  Copyright © 2015 Jan Nash. All rights reserved.
//

import Foundation
import CoreData


// MARK: Public Interface
public extension SWObjectManager {
    // Default Context
    public static var defaultObjectContext: NSManagedObjectContext {
        get             {return self._defaultObjectContext}
        set(newContext) {self._defaultObjectContext = newContext}
    }
    
    // Creation/Deletion
    public func create<T: SWManagedObject>() -> T {
        return self._create()
    }
    
    public func delete<T: SWManagedObject>(obj: T) {
        self._delete(obj)
    }
    
    // Basic Queries
    public func all() -> SWRefinableQuerySet {
        return self._all()
    }
}


// MARK: Main Implementation
public class SWObjectManager: SWQuerySetGenerator {
    // Private Static Variable Properties
    private static var __defaultObjectContext: NSManagedObjectContext!
    
    // MARK: Override throwing fatalError, will be there until protected is hopefully implemented in Swift
    override func __objects__() -> [SWManagedObject] {
        fatalError("SWQuerySetEvaluator.__objects__() is meant for" +
                   "subclass use only. To get all objects of class " +
                   "\(self.className), please use \(self.className).objects.all()"
        )
    }
}


// MARK: Private Computed Properties
private extension SWObjectManager {
    private static var _defaultObjectContext: NSManagedObjectContext {
        get {
            if self.__defaultObjectContext == nil {
                fatalError("ProgrammingError: SWObjectManager has not been assigned a defaultObjectContext" +
                           "and no individual object context was specified on the SWQuerySet that has been executed. " +
                           "Please make sure to assign a defaultObjectContext before executing any QuerySets!")
            }
            return self.__defaultObjectContext
        }
        set(newContext) {
            self.__defaultObjectContext = newContext
        }
    }
}


// MARK: Creation/Deletion
private extension SWObjectManager {
    // Creation/Deletion
    private func _create<T: SWManagedObject>() -> T {
        return NSEntityDescription.insertNewObjectForEntityForName(self.className, inManagedObjectContext: self.objectContext) as! T
    }
    
    private func _delete<T: SWManagedObject>(obj: T) {
        self.objectContext.deleteObject(obj)
    }
}


// MARK: Basic Queries
private extension SWObjectManager {
    private func _all() -> SWRefinableQuerySet {
        return SWRefinableQuerySet(withClass: self.klass, objectContext: self.objectContext)
    }
}


