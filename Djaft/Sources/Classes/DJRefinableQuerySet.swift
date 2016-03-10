//
//  DJRefinableQuerySet.swift
//  Djaft
//
//  Created by Jan Nash on 22/11/15.
//  Copyright © 2015 Jan Nash. All rights reserved.
//

import Foundation
import CoreData
//import Synchronized


// MARK: // Public 
// MARK: Interface
public extension DJRefinableQuerySet {
    // Get Sliced QuerySet
    // (Does not evaluate, returns DJFinalQuerySet that does not allow more refinements)
    public subscript(startIndex: Int, endIndex: Int) -> DJFinalQuerySet {
        return self._getSlicedQuerySet(startIndex, endIndex: endIndex)
    }
    
    // Get Objects From Start To End With Step
    // (Evaluates)
    public subscript(startIndex: Int, endIndex: Int, stepSize: Int) -> [T] {
        return self._objectsFromStart(startIndex, toEnd: endIndex, withStepSize: stepSize)
    }
    
    // QuerySet Generation
    public func filter(params: String...) -> DJRefinableQuerySet {
        return self._querySetCreator.__filter__(params)
    }
    
    public func exclude(params: String...) -> DJRefinableQuerySet {
        return self._querySetCreator.__exclude__(params)
    }
    
    public func orderBy(params: String...) -> DJRefinableQuerySet {
        return self._querySetCreator.__orderBy__(params)
    }
}


// MARK: Class Declaration
public class DJRefinableQuerySet: DJMetaQuerySet {
    private var __querySetCreator: DJQuerySetCreator!
}


// MARK: // Private 
// MARK: Computed Properties
private extension DJRefinableQuerySet {
    private var _querySetCreator: DJQuerySetCreator {
        if self.__querySetCreator == nil {
            self.__querySetCreator = DJQuerySetCreator(
                withClass: self.klass,
                objectContext: self.objectContext,
                filters: self.filters,
                excludes: self.excludes,
                orderBys: self.orderBys
            )
        }
        return self.__querySetCreator
    }
}


// MARK: Get Sliced QuerySet
private extension DJRefinableQuerySet {
    private func _getSlicedQuerySet(startIndex: Int, endIndex: Int) -> DJFinalQuerySet {
        var objects: [T]?
        if self.isFetched {
            objects = self.__objects__()
        }
        
        var limit: Int = endIndex - startIndex
        if limit <= 0 {
            print("WARNING: Created SlicedQuerySet with a limit <= 0. " +
                  "This is most likely caused by an erratic subscript-usage. " +
                  "This QuerySet will never return any objects.")
            limit = 0
        }
        
        return DJFinalQuerySet(
            withClass: self.klass,
            objectContext: self.objectContext,
            offset: startIndex,
            limit: limit,
            filters: self.filters,
            excludes: self.excludes,
            orderBys: self.orderBys,
            fetchedObjects: objects
        )
    }
}


// MARK: Get Objects From Start To End With Step
private extension DJMetaQuerySet {
    private func _objectsFromStart(startIndex: Int, toEnd endIndex: Int, withStepSize stepSize: Int) -> [T] {
        self.evaluate()
        var result: [T] = []
        var index: Int = startIndex
        while index < endIndex {
            result.append(self[index]!)
            index += stepSize
        }
        return result
    }
}
