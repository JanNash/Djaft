//
//  SWQuerySetGenerator.swift
//  Swango
//
//  Created by Jan Nash on 16/11/15.
//  Copyright © 2015 Jan Nash. All rights reserved.
//

import Foundation
import CoreData


// MARK: Public Interface
public extension SWQuerySetGenerator {
    // QuerySet Generation
    public func filter(firstPredicate: String, _ otherPredicates: String...) -> SWRefinableQuerySet {
        return self._filter([firstPredicate] + otherPredicates)
    }
    
    public func exclude(firstPredicate: String, _ otherPredicates: String...) -> SWRefinableQuerySet {
        return self._exclude([firstPredicate] + otherPredicates)
    }
}


// MARK: Compositing Class Interface (No splatting possible yet in Swift...)
extension SWQuerySetGenerator {
    // QuerySet Generation
    func __filter__(params: [String]) -> SWRefinableQuerySet {
        return self._filter(params)
    }
    
    func __exclude__(params: [String]) -> SWRefinableQuerySet {
        return self._exclude(params)
    }
}


// MARK: Main Implementation
public class SWQuerySetGenerator: SWQuerySetEvaluator {}


// MARK: QuerySet Generation
private extension SWQuerySetGenerator {
    private func _filter(params: [String]) -> SWRefinableQuerySet {
        return SWRefinableQuerySet(
            withClass: self.klass,
            objectContext: self.objectContext,
            filters: self.filters + params,
            excludes: self.excludes,
            orderBys: self.orderBys
        )
    }
    
    private func _exclude(params: [String]) -> SWRefinableQuerySet {
        return SWRefinableQuerySet(
            withClass: self.klass,
            objectContext: self.objectContext,
            filters: self.filters,
            excludes: self.excludes + params,
            orderBys: self.orderBys
        )
    }
}

