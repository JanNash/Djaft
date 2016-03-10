//
//  DJFinalQuerySet.swift
//  Djaft
//
//  Created by Jan Nash on 12/12/15.
//  Copyright © 2015 Jan Nash. All rights reserved.
//

import Foundation
import CoreData


// MARK: // Public
// MARK: Class Declaration
public class DJFinalQuerySet: DJMetaQuerySet {
    private var _offset: Int
    private var _limit: Int
}


// MARK: // Internal
// MARK: Initialization
extension DJFinalQuerySet {
    init(_withClass klass: NSManagedObject.Type,
        objectContext: NSManagedObjectContext? = nil,
        offset: Int = 0,
        limit: Int = -1,
        filters: [String] = [],
        excludes: [String] = [],
        orderBys: [String] = [],
        fetchedObjects: [T]? = nil) {
            
            self._offset = offset
            self._limit = limit
            
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
