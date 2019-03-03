//
//  DJQuerySetCreator.swift
//  Djaft
//
//  Created by Jan Nash on 16/11/15.
//  Copyright © 2015 Jan Nash. All rights reserved.
//

import Foundation
import CoreData


// MARK: // Internal
// MARK: Interface
extension DJQuerySetCreator {
    // Basic QuerySet Generation
    func createRefinableQuerySet_(newFilters newFilters: [String] = [], newExcludes: [String] = [], newOrderBys: [String] = []) -> DJRefinableQuerySet<T> {
        return self._createRefinableQuerySet(
            newFilters: newFilters,
            newExcludes: newExcludes,
            newOrderBys: newOrderBys
        )
    }
    
    // Refined QuerySet Generation
    func filter_(params: [String]) -> DJRefinableQuerySet<T> {
        return self._filter(params)
    }
    
    func exclude_(params: [String]) -> DJRefinableQuerySet<T> {
        return self._exclude(params)
    }
    
    func orderBy_(params: [String]) -> DJRefinableQuerySet<T> {
        return self._orderBy(params)
    }
}


// MARK: Class Declaration
class DJQuerySetCreator<T: NSManagedObject>: DJQuerySetEvaluator<T> {
    override init(withClass klass: NSManagedObject.Type,
                            objectContext: NSManagedObjectContext? = nil,
                            filters: [String] = [],
                            excludes: [String] = [],
                            orderBys: [String]? = nil,
                            fetchedObjects: [T]? = nil) {
        super.init(
            withClass: klass,
            objectContext: objectContext,
            filters: filters,
            excludes: excludes,
            orderBys: orderBys,
            fetchedObjects: fetchedObjects
        )
    }
}


// MARK: // Private
// MARK: Basic QuerySet Generation
private extension DJQuerySetCreator {
    private func _createRefinableQuerySet(newFilters newFilters: [String] = [], newExcludes: [String] = [], newOrderBys: [String] = []) -> DJRefinableQuerySet<T> {
        return DJRefinableQuerySet(
            withClass: self.klass_,
            objectContext: self.objectContext,
            filters: self.filters + newFilters,
            excludes: self.excludes + newExcludes,
            orderBys: self.orderBys + newOrderBys
        )
    }
}


// MARK: Refined QuerySet Generation
private extension DJQuerySetCreator {
    private func _filter(params: [String]) -> DJRefinableQuerySet<T> {
        return self._createRefinableQuerySet(newFilters: params)
    }
    
    private func _exclude(params: [String]) -> DJRefinableQuerySet<T> {
        return self._createRefinableQuerySet(newExcludes: params)
    }
    
    private func _orderBy(params: [String]) -> DJRefinableQuerySet<T> {
        return self._createRefinableQuerySet(newOrderBys: params)
    }
}
