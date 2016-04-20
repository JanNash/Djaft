//
//  DJQuerySetOutputGenerator.swift
//  Djaft
//
//  Created by Jan Nash on 4/20/16.
//  Copyright © 2016 Jan Nash. All rights reserved.
//

import Foundation
import CoreData


// MARK: // Public
// MARK: GeneratorType Extension
public extension DJQuerySetOutputGenerator {
    public mutating func next() -> T? {
        return self._next()
    }
}


// MARK: for-in Iteration Support
public struct DJQuerySetOutputGenerator<T: NSManagedObject>: GeneratorType {
    // Initialization
    internal init(objects: [T]) {
        self._objects = objects
    }
    
    // Private Stored Properties
    private let _objects: [T]
    private var _indexInSequence: Int = 0
}


// MARK: // Private
// MARK: next() implementation
private extension DJQuerySetOutputGenerator {
    private mutating func _next() -> T? {
        if self._indexInSequence > self._objects.count {
            return nil
        } else {
            let result: T = self._objects[self._indexInSequence]
            self._indexInSequence += 1
            return result
        }
    }
}
