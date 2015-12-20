//
//  SWMetaQuerySet.swift
//  Swango
//
//  Created by Jan Nash on 12/13/15.
//  Copyright © 2015 Jan Nash. All rights reserved.
//

import Foundation
import CoreData


// MARK: Public Interface
public extension SWMetaQuerySet {
    // Get Object At Index
    // (Evaluates)
    public subscript(position: Int) -> NSManagedObject? {
        return self._getObjectAtIndex(position)
    }
}


// MARK: for-in Iteration Support
extension SWMetaQuerySet: SequenceType {
    // Evaluates
    public func generate() -> NSFastGenerator {
        return NSFastGenerator(self.__objects__())
    }
}


// MARK: Main Implementation
public class SWMetaQuerySet: SWQuerySetEvaluator {}


// MARK: // Subscript Implementation Logic
// MARK: Get Object At Index
private extension SWMetaQuerySet {
    private func _getObjectAtIndex(index: Int) -> NSManagedObject? {
        return self.__objects__()[index]
    }
}
