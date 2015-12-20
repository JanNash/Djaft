//
//  SWRefinableQuerySet.swift
//  Swango
//
//  Created by Jan Nash on 22/11/15.
//  Copyright © 2015 Jan Nash. All rights reserved.
//

import Foundation
import CoreData
//import Synchronized


// Public Interface
public extension SWRefinableQuerySet {
    // Get Sliced QuerySet
    // (Does not evaluate, returns SWFinalQuerySet that does not allow more refinements)
    public subscript(startIndex: Int, endIndex: Int) -> SWFinalQuerySet {
        return self._getSlicedQuerySet(startIndex, endIndex: endIndex)
    }
    
    // Get Objects From Start To End With Step
    // (Evaluates)
    public subscript(startIndex: Int, endIndex: Int, stepSize: Int) -> [NSManagedObject] {
        return self._objectsFromStart(startIndex, toEnd: endIndex, withStepSize: stepSize)
    }
    
    // QuerySet Generation
    public func filter(params: String...) -> SWRefinableQuerySet {
        return self._querySetGenerator.__filter__(params)
    }
    
    public func exclude(params: String...) -> SWRefinableQuerySet {
        return self._querySetGenerator.__exclude__(params)
    }
    
    public func orderBy(params: String...) -> SWRefinableQuerySet {
        return self._querySetGenerator.__orderBy__(params)
    }
}


// MARK: Main Implementation
public class SWRefinableQuerySet: SWMetaQuerySet {
    private var __querySetGenerator: SWQuerySetGenerator!
}


// MARK: Private Computed Properties
private extension SWRefinableQuerySet {
    private var _querySetGenerator: SWQuerySetGenerator {
        if self.__querySetGenerator == nil {
            self.__querySetGenerator = SWQuerySetGenerator(
                withClass: self.klass,
                objectContext: self.objectContext,
                filters: self.filters,
                excludes: self.excludes,
                orderBys: self.orderBys
            )
        }
        return self.__querySetGenerator
    }
}


// MARK: Get Sliced QuerySet
private extension SWRefinableQuerySet {
    private func _getSlicedQuerySet(startIndex: Int, endIndex: Int) -> SWFinalQuerySet {
        var objects: [NSManagedObject]?
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
        
        return SWFinalQuerySet(
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
private extension SWMetaQuerySet {
    private func _objectsFromStart(startIndex: Int, toEnd endIndex: Int, withStepSize stepSize: Int) -> [NSManagedObject] {
        self.evaluate()
        var result: [NSManagedObject] = []
        var index: Int = startIndex
        while index < endIndex {
            result.append(self[index]!)
            index += stepSize
        }
        return result
    }
}


