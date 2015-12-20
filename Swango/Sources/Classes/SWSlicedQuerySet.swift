//
//  SWSlicedQuerySet.swift
//  Swango
//
//  Created by Jan Nash on 12/12/15.
//  Copyright © 2015 Jan Nash. All rights reserved.
//

import Foundation
import CoreData


// MARK: Main Implementation
public class SWSlicedQuerySet: SWMetaQuerySet {
    // Initialization
    init(withClass klass: NSManagedObject.Type,
         objectContext: NSManagedObjectContext? = nil,
         offset: Int,
         limit: Int,
         filters: [String] = [],
         excludes: [String] = [],
         orderBys: [String] = [],
         fetchedObjects: [NSManagedObject]? = nil) {
            
        super.init(
            withClass: klass,
            objectContext: objectContext,
            filters: filters,
            excludes: excludes,
            orderBys: orderBys,
            fetchedObjects: fetchedObjects
        )
        
        self._offset = offset
        self._limit = limit
    }
    
    private var _offset: Int = 0
    private var _limit: Int = 0
}