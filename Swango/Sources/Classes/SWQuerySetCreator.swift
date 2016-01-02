//
//  SWQuerySetCreator.swift
//  Swango
//
//  Created by Jan Nash on 16/11/15.
//  Copyright © 2015 Jan Nash. All rights reserved.
//

import Foundation
import CoreData


// MARK: Internal Interface
internal class SWQuerySetCreator: SWQuerySetEvaluator {
    // Basic QuerySet Generation
    internal func __createRefinableQuerySet__(
        withNewFilters newFilters: [String] = [],
        withNewExcludes newExcludes: [String] = [],
        withNewOrderBys newOrderBys: [String] = []) -> SWRefinableQuerySet {
            return self._createRefinableQuerySet(
                withNewFilters: newFilters,
                withNewExcludes: newExcludes,
                withNewOrderBys: newOrderBys
            )
    }
    
    // Refined QuerySet Generation
    internal func __filter__(params: [String]) -> SWRefinableQuerySet {
        return self._filter(params)
    }
    
    internal func __exclude__(params: [String]) -> SWRefinableQuerySet {
        return self._exclude(params)
    }
    
    internal func __orderBy__(params: [String]) -> SWRefinableQuerySet {
        return self._orderBy(params)
    }
}


// MARK: Basic QuerySet Generation
private extension SWQuerySetCreator {
    private func _createRefinableQuerySet(
        withNewFilters newFilters: [String] = [],
        withNewExcludes newExcludes: [String] = [],
        withNewOrderBys newOrderBys: [String] = []) -> SWRefinableQuerySet {
            return SWRefinableQuerySet(
                withClass: self.klass,
                objectContext: self.objectContext,
                filters: self.filters + newFilters,
                excludes: self.excludes + newExcludes,
                orderBys: self.orderBys + newOrderBys
            )
    }
}


// Refined QuerySet Generation
private extension SWQuerySetCreator {
    private func _filter(params: [String]) -> SWRefinableQuerySet {
        return self._createRefinableQuerySet(withNewFilters: params)
    }
    
    private func _exclude(params: [String]) -> SWRefinableQuerySet {
        return self._createRefinableQuerySet(withNewExcludes: params)
    }
    
    private func _orderBy(params: [String]) -> SWRefinableQuerySet {
        return self._createRefinableQuerySet(withNewOrderBys: params)
    }
}

