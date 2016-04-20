//
//  DJQuerySetEvaluator.swift
//  Djaft
//
//  Created by Jan Nash on 12/13/15.
//  Copyright © 2015 Jan Nash. All rights reserved.
//

import Foundation
import CoreData
import Synchronized


// MARK: // Public 
// MARK: Interface
public extension DJQuerySetEvaluator {
    // // // Variable Read-Write Properties
    // Object Context
    public var objectContext: NSManagedObjectContext {
        get {
            return self._objectContext
        }
        set(newContext) {
            self._objectContext = newContext
        }
    }
    
    // Evaluation State
    public var isCounted: Bool {
        return self._isCounted
    }
    
    public var isFetched: Bool {
        return self._isFetched
    }
    
    // Fetch Properties
    public var offset: Int {
        return self._offset
    }
    
    public var limit: Int {
        return self._limit
    }
    
    public var filters: [String] {
        return self._filters
    }
    
    public var excludes: [String] {
        return self._excludes
    }
    
    public var orderBys: [String] {
        return self._orderBys ?? self.klass_.defaultOrderBys
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
        return self.count_()
    }
}


// MARK: Class Declaration
public class DJQuerySetEvaluator<T: NSManagedObject>: AnyObject {
    // Initialization
    init(withClass klass: NSManagedObject.Type,
        objectContext: NSManagedObjectContext? = nil,
        filters: [String] = [],
        excludes: [String] = [],
        orderBys: [String]? = nil,
        fetchedObjects: [T]? = nil) {
            
        self._klass = klass
        self._objectContext = objectContext
        
        self._filters = filters
        self._excludes = excludes
        self._orderBys = orderBys
        
        self._validateFilters()
        self._validateExcludes()
        self._validateOrderBys()
        
        self._objects = fetchedObjects
        self._count = fetchedObjects?.count
    }
    
    // Private Constant Properties
    private let _klass: NSManagedObject.Type!
    
    // Private Variable Properties
    private var _objectContext: NSManagedObjectContext!
    private var _fetchRequest: NSFetchRequest?
    
    // Fetch Configuration Properties
    // Constants
    private let _offset: Int = 0
    private let _limit: Int = 0
    // Variables
    private var _filters: [String] = []
    private var _excludes: [String] = []
    private var _orderBys: [String]?
    
    // Evaluation Caches
    private var _count: Int?
    private var _objects: [T]?
}


// MARK: // Internal
// MARK: Interface
extension DJQuerySetEvaluator {
    // // // Variable Readonly Properties
    // // Class Information
    var klass_: NSManagedObject.Type {
        return self._klass
    }
    
    var className_: String {
        return self._className
    }
    
    // // Functions
    // Objects (Evaluates)
    func objects_() -> [T] {
        self._fetchObjectsIfNecessary()
        return self._objects!
    }
    
    // Count (Only Gets Count)
    func count_() -> Int {
        self._getCountIfNecessary()
        return self._count!
    }
}


// MARK: // Private 
// MARK: Computed Properties
private extension DJQuerySetEvaluator {
    // Object Context
    private var _objectContext: NSManagedObjectContext {
        get {
            return self._objectContext
        }
        set(newContext) {
            self._objectContext = newContext
        }
    }
    
    // Class Name
    private var _className: String {
        return NSStringFromClass(self.klass_).componentsSeparatedByString(".").last!
    }
    
    // Evaluation State
    private var _isCounted: Bool {
        return self._count != nil
    }
    
    private var _isFetched: Bool {
        return self._objects != nil
    }
}


// MARK: Force Evaluate
private extension DJQuerySetEvaluator {
    private func _evaluate() {
        synchronized(self) {
            self._fetchObjectsIfNecessary()
            self._count = self._objects!.count
        }
    }
}


// MARK: Reset
private extension DJQuerySetEvaluator {
    private func _reset() {
        synchronized(self) {
            self._objects = nil
            self._count = nil
        }
    }
}


// MARK: Initialization Validation
private extension DJQuerySetEvaluator {
    private func _validateFilters() {
        // TODO
    }
    
    private func _validateExcludes() {
        // TODO
    }
    
    private func _validateOrderBys() {
        // TODO
    }
    
}

// MARK: Construct FetchRequest
private extension DJQuerySetEvaluator {
    private func _getFetchRequest() -> NSFetchRequest {
        return synchronized(self) {
            if self._fetchRequest == nil {
                self._fetchRequest = NSFetchRequest(entityName: self._className)
                self._fetchRequest!.fetchOffset = self.offset
                self._fetchRequest!.fetchLimit = self.limit
                
                var filterPredicates: [NSPredicate] = []
                for filter in self.filters {
                    filterPredicates.append(NSPredicate(format: filter))
                }
                
                var excludePredicates: [NSPredicate] = []
                for exclude in self.excludes {
                    excludePredicates.append(NSPredicate(format: exclude))
                }
                
                // (filter AND filter AND filter):
                let filterPredicate: NSCompoundPredicate = NSCompoundPredicate(
                    andPredicateWithSubpredicates: filterPredicates
                )
                // (exclude OR exclude OR exclude):
                let orCombinedExcludePredicate: NSCompoundPredicate = NSCompoundPredicate(
                    orPredicateWithSubpredicates: excludePredicates
                )
                // NOT (exclude OR exclude OR exclude):
                let negatedExcludePredicate: NSCompoundPredicate = NSCompoundPredicate(
                    notPredicateWithSubpredicate: orCombinedExcludePredicate
                )
                // (filter AND filter AND filter) AND NOT (exclude OR exclude OR exclude):
                let completePredicate: NSCompoundPredicate = NSCompoundPredicate(
                    andPredicateWithSubpredicates: [filterPredicate, negatedExcludePredicate]
                )
                
                self._fetchRequest!.predicate = completePredicate
                
                var sortDescriptors: [NSSortDescriptor] = []
                for orderBys in self.orderBys {
                    let ascending: Bool = orderBys[orderBys.startIndex] != "-"
                    let sortDescriptor: NSSortDescriptor = NSSortDescriptor(
                        key: orderBys,
                        ascending: ascending
                    )
                    sortDescriptors.append(sortDescriptor)
                }
                
                self._fetchRequest!.sortDescriptors = sortDescriptors
            }
            return self._fetchRequest!
        }
    }
}


// MARK: Get Objects / Get Count
private extension DJQuerySetEvaluator {
    private func _getCountIfNecessary() {
        synchronized(self) {
            if self._count != nil {
                return
            }
            
            if self._objects != nil {
                self._count = self._objects!.count
                return
            }
            
            let context: NSManagedObjectContext = self.objectContext
            let fetchRequest: NSFetchRequest = self._getFetchRequest()
            let errorPointer: NSErrorPointer = nil
            self._count = context.countForFetchRequest(
                fetchRequest,
                error: errorPointer
            )
            if errorPointer != nil {
                // TODO!
                printErrorFromPointer(errorPointer)
            }
        }
    }
    
    private func _fetchObjectsIfNecessary() {
        synchronized(self) {
            if self._objects != nil {
                return
            }
            
            let context: NSManagedObjectContext = self.objectContext
            let fetchRequest: NSFetchRequest = self._getFetchRequest()
            do {
                try self._objects = context.executeFetchRequest(fetchRequest) as? [T]
            } catch let error as NSError {
                // TODO!
                printError(error)
            }
        }
    }
}
