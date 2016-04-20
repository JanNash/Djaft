//
//  DJMetaQuerySet.swift
//  Djaft
//
//  Created by Jan Nash on 12/13/15.
//  Copyright © 2015 Jan Nash. All rights reserved.
//

import Foundation
import CoreData


// MARK: // Public
// MARK: Subscript
public extension DJMetaQuerySet {
    // Get Object At Index
    // (Evaluates)
    public subscript(position: Int) -> T? {
        return self._getObjectAtIndex(position)
    }
}


// MARK: SequenceType Extension
extension DJMetaQuerySet: SequenceType {
    // Evaluates
    public func generate() -> DJQuerySetOutputGenerator<T> {
        return DJQuerySetOutputGenerator(objects: self.objects_())
    }
}


// MARK: Class Declaration
public class DJMetaQuerySet<T: NSManagedObject>: DJQuerySetEvaluator<T> {
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
// MARK: Subscript Implementation Logic
// Get Object At Index
private extension DJMetaQuerySet {
    private func _getObjectAtIndex(index: Int) -> T? {
        return self.objects_()[index]
    }
}



