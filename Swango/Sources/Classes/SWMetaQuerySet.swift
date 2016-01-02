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


public struct SWQuerySetGenerator: GeneratorType {
    private let _objects: [NSManagedObject]
    private var _indexInSequence: Int = 0
    
    internal init<T: NSManagedObject>(objects: [T]) {
        self._querySet = querySet
    }
    
    public mutating func next() -> NSManagedObject? {
        
    }
}


// MARK: for-in Iteration Support
extension SWMetaQuerySet: SequenceType {
    // Evaluates
    public func generate() -> SWQuerySetGenerator {
        return SWQuerySetGenerator(querySet: self)
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
