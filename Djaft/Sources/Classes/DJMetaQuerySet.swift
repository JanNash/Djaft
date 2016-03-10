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
    public func generate() -> GeneratorOf<T> {
        return DJQuerySetGenerator(self.__objects__())
    }
}


// MARK: Class Declaration
public class DJMetaQuerySet: DJQuerySetEvaluator {}


// MARK: // Private
// MARK: Subscript Implementation Logic
// Get Object At Index
private extension DJMetaQuerySet where T: NSManagedObject {
    private func _getObjectAtIndex(index: Int) -> T? {
        return self.__objects__()[index]
    }
}


// MARK: for-in Iteration Support
public struct DJQuerySetGenerator<T: NSManagedObject>: GeneratorType {
    private let _objects: [T]
    private var _indexInSequence: Int = 0
    
    internal init<T: NSManagedObject>(objects: [T]) {
        self._objects = objects
    }
    
    public mutating func next() -> T? {
        if self._indexInSequence > self._objects.count {
            return nil
        } else {
            let result: T = self._objects[self._indexInSequence++]
            self._indexInSequence += 1
            return result
        }
    }
}
