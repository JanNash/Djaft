//
//  SWQuerySetEvaluator.swift
//  Swango
//
//  Created by Jan Nash on 12/13/15.
//  Copyright © 2015 Jan Nash. All rights reserved.
//

import Foundation
import CoreData
//import Synchronized


// MARK: Public Interface
public extension SWQuerySetEvaluator {
    // // // Variable Read-Write Properties
    // Object Context
    public var objectContext: NSManagedObjectContext {
        get             {return self._objectContext}
        set(newContext) {self._objectContext = newContext}
    }
    
    // // // Variable Readonly Properties
    // // Class Information
    public var klass: SWManagedObject.Type {
        get {return self._klass}
    }
    
    public var className: String {
        get {return self._className}
    }
    
    // Evaluation State
    public var isCounted: Bool {
        get {return self._isCounted}
    }
    
    public var isFetched: Bool {
        get {return self._isFetched}
    }
    
    // Fetch Properties
    public var offset: Int {
        get {return self._offset}
    }
    
    public var limit: Int {
        get {return self._limit}
    }
    
    public var filters: [String] {
        get {return self._filters}
    }
    
    public var excludes: [String] {
        get {return self._excludes}
    }
    
    public var ordeSWys: [String] {
        get {return self._ordeSWys}
    }
    
    // // Functions
    // Force Evaluate
    public func evaluate() {
        self._evaluate()
    }
    
    // Reset
    public func reset() {
        self._reset()
    }
    
    // Count
    public func count() -> Int {
        return self.__count__()
    }
}


// MARK: Main Implementation
public class SWQuerySetEvaluator: AnyObject {
    // Initialization
    init(withClass klass: SWManagedObject.Type,
         objectContext: NSManagedObjectContext? = nil,
         filters: [String] = [],
         excludes: [String] = [],
         ordeSWys: [String] = [],
         fetchedObjects: [SWManagedObject]? = nil) {
            
        self._klass = klass
        self.__objectContext = objectContext
        
        self._filters = filters
        self._excludes = excludes
        self._ordeSWys = ordeSWys
        
        self._validateFilters()
        self._validateExcludes()
        self._validateOrdeSWys()
        
        self.__objects = fetchedObjects
        self.__count = fetchedObjects?.count
    }
    
    // Private Constant Properties
    private let _klass: SWManagedObject.Type!
    
    // Private Variable Properties
    private var __objectContext: NSManagedObjectContext?
    private var __fetchRequest: NSFetchRequest?
    
    // Fetch Properties
    // Constant
    private let _offset: Int = 0
    private let _limit: Int = 0
    // Variable
    private var _filters: [String]
    private var _excludes: [String]
    private var _ordeSWys: [String]
    
    // Evaluation
    private var __count: Int?
    private var __objects: [SWManagedObject]?
    
    // // Functions
    // Objects (Evaluates)
    func __objects__() -> [SWManagedObject] {
        self._fetchObjectsIfNecessary()
        return self.__objects!
    }
    
    // Count (Only Gets Count)
    func __count__() -> Int {
        self._getCountIfNecessary()
        return self.__count!
    }
}



// MARK: // Backing For Public Variables And Functions
// MARK: Private Computed Properties
private extension SWQuerySetEvaluator {
    // Object Context
    private var _objectContext: NSManagedObjectContext {
        get {
            if self.__objectContext != nil {
                return self.__objectContext!
            } else {
                return SWObjectManager.defaultObjectContext
            }
        }
        set(newContext) {
            self.__objectContext = newContext
        }
    }
    
    // Class Name
    private var _className: String {
        return NSStringFromClass(self.klass).componentsSeparatedByString(".").last!
    }
    
    // Evaluation State
    private var _isCounted: Bool {
        return self.__count != nil
    }
    
    private var _isFetched: Bool {
        return self.__objects != nil
    }
}


// MARK: Force Evaluate
private extension SWQuerySetEvaluator {
    private func _evaluate() {
//        synchronized(self) {
            self._fetchObjectsIfNecessary()
            self.__count = self.__objects!.count
//        }
    }
}


// MARK: Reset
private extension SWQuerySetEvaluator {
    private func _reset() {
//        synchronized(self) {
            self.__objects = nil
            self.__count = nil
//        }
    }
}



// MARK: // Private Implementation Logic
// MARK: Initialization Validation
private extension SWQuerySetEvaluator {
    private func _validateFilters() {
        
    }
    
    private func _validateExcludes() {
        
    }
    
    private func _validateOrdeSWys() {
        
    }
    
}

// MARK: Construct FetchRequest
private extension SWQuerySetEvaluator {
    private var _fetchRequest: NSFetchRequest {
//        synchronized(self) {
            if self.__fetchRequest == nil {
                print("constructing fetchRequest")
                self.__fetchRequest = NSFetchRequest(entityName: self._className)
                self.__fetchRequest!.fetchOffset = self.offset
                self.__fetchRequest!.fetchLimit = self.limit
                
                var filterPredicates: [NSPredicate] = []
                for filter in self.filters {
                    filterPredicates.append(NSPredicate(format: filter))
                }
                
                var excludePredicates: [NSPredicate] = []
                for exclude in self.excludes {
                    excludePredicates.append(NSPredicate(format: exclude))
                }
                
                // (filter AND filter AND filter):
                let filterPredicate: NSCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: filterPredicates)
                // (exclude OR exclude OR exclude):
                let orCombinedExcludePredicate: NSCompoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: excludePredicates)
                // NOT (exclude OR exclude OR exclude):
                let negatedExcludePredicate: NSCompoundPredicate = NSCompoundPredicate(notPredicateWithSubpredicate: orCombinedExcludePredicate)
                // (filter AND filter AND filter) AND NOT (exclude OR exclude OR exclude):
                let completePredicate: NSCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [filterPredicate, negatedExcludePredicate])
                
                self.__fetchRequest!.predicate = completePredicate
                
                var sortDescriptors: [NSSortDescriptor] = []
                for ordeSWy in self.ordeSWys {
                    let ascending: Bool = ordeSWy[ordeSWy.startIndex] != "-"
                    sortDescriptors.append(NSSortDescriptor(key: ordeSWy, ascending: ascending))
                }
                
                self.__fetchRequest!.sortDescriptors = sortDescriptors
            }
//        }
        return self.__fetchRequest!
    }
}


// MARK: Get Objects / Get Count
private extension SWQuerySetEvaluator {
    private func _getCountIfNecessary() {
//        synchronized(self) {
            if self.__count == nil {
                if self.__objects != nil {
                    self.__count = self.__objects!.count
                } else {
                    print("Getting count for FetchRequest")
                    let errorPointer: NSErrorPointer = NSErrorPointer()
                    self.__count = self.objectContext.countForFetchRequest(self._fetchRequest, error: errorPointer)
                    if errorPointer != nil {
                        printErrorFromPointer(errorPointer)
                    }
                }
            }
//        }
    }
    
    private func _fetchObjectsIfNecessary() {
//        synchronized(self) {
            if self.__objects == nil {
                do {
                    print("Executing FetchRequest")
                    try self.__objects = self.objectContext.executeFetchRequest(self._fetchRequest) as? [SWManagedObject]
                } catch let error as NSError {
                    printError(error)
                }
            }
//        }
    }
}


