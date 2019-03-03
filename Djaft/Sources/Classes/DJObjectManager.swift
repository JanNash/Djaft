//
//  DJObjectManager.swift
//  Djaft
//
//  Created by Jan Nash on 16/11/15.
//  Copyright © 2015 Jan Nash. All rights reserved.
//

import Foundation
import CoreData


// MARK: // Public
// MARK: Interface
public extension DJObjectManager {
    // Default Context
    public static var defaultObjectContext: NSManagedObjectContext {
        get {
            return self._defaultObjectContext
        }
        set(newContext) {
            self._defaultObjectContext = newContext
        }
    }
    
    // Creation/Deletion
    public func create() -> T {
        return self._create()
    }
    
    public func delete(obj: T) {
        self._delete(obj)
    }
    
    // Basic Queries
    public func all() -> DJFinalQuerySet<T> {
        return self._all()
    }
    
    // QuerySet Generation
    public func filter(params: String...) -> DJRefinableQuerySet<T> {
        return self._filter(params)
    }
    
    public func exclude(params: String...) -> DJRefinableQuerySet<T> {
        return self._exclude(params)
    }
    
    public func orderBy(params: String...) -> DJRefinableQuerySet<T> {
        return self._orderBy(params)
    }
}


// MARK: Class Declaration
public class DJObjectManager<T: NSManagedObject>: DJQuerySetEvaluator<T> {
    // MARK: // Internal
    // MARK: Initialization
    init(withClass klass: NSManagedObject.Type,
        objectContext: NSManagedObjectContext? = nil,
        filters: [String] = [],
        excludes: [String] = [],
        orderBys: [String]? = nil,
        fetchedObjects: [NSManagedObject]? = nil) {
            super.init(
                withClass: klass,
                objectContext: DJObjectManager.defaultObjectContext
            )
    }
    
    // MARK: Stored Properties
    private var _querySetCreator: DJQuerySetCreator<T>!
}


// MARK: // Private
// MARK: DJObjectManagerDefaultObjectContext
private var __defaultObjectContext: NSManagedObjectContext!
private extension DJObjectManager {
    private static var _defaultObjectContext: NSManagedObjectContext {
        get {
            if __defaultObjectContext == nil {
                fatalError(
                    "ProgrammingError: DJObjectManager.defaultObjectContext was not specified, " +
                    "nor was an individual object context specified on the DJQuerySet that has " +
                    "been executed. Please make sure to assign a defaultObjectContext or an " +
                    "individual context before executing any QuerySets!"
                )
            }
            return __defaultObjectContext
        }
        set(newContext) {
            __defaultObjectContext = newContext
        }
    }
}


// MARK: Creation/Deletion
private extension DJObjectManager {
    // Creation/Deletion
    private func _create<T: NSManagedObject>() -> T {
        return NSEntityDescription.insertNewObjectForEntityForName(
            self.className_,
            inManagedObjectContext: self.objectContext
        ) as! T
    }
    
    private func _delete<T: NSManagedObject>(obj: T) {
        self.objectContext.deleteObject(obj)
    }
}


// MARK: Basic Queries
private extension DJObjectManager {
    private func _all() -> DJFinalQuerySet<T> {
        return DJFinalQuerySet(
            _withClass: self.klass_,
            objectContext: self.objectContext
        )
    }
}


// MARK: QuerySet Generation
private extension DJObjectManager {
    private func _filter(params: [String]) -> DJRefinableQuerySet<T> {
        return self._getQuerySetCreator().__filter__(params)
    }
    
    private func _exclude(params: [String]) -> DJRefinableQuerySet<T> {
        return self._getQuerySetCreator().__exclude__(params)
    }
    
    private func _orderBy(params: [String]) -> DJRefinableQuerySet<T> {
        return self._getQuerySetCreator().__orderBy__(params)
    }
    
    private func _getQuerySetCreator() -> DJQuerySetCreator<T> {
        if self._querySetCreator == nil {
            self._querySetCreator = DJQuerySetCreator(
                withClass: self.klass_,
                objectContext: self.objectContext,
                filters: self.filters,
                excludes: self.excludes,
                orderBys: self.orderBys
            )
        }
        return self._querySetCreator
    }
}
