//
//  ObjectManagerPossessingType.swift
//  Djaft
//
//  Created by Jan Nash on 4/20/16.
//  Copyright © 2016 Jan Nash. All rights reserved.
//

import Foundation
import CoreData


// MARK: // Public
// MARK: Protocol Declaration
public protocol ObjectManagerPossessingType: class {
    associatedtype QuerySetProducedClass: NSManagedObject
}


// MARK: Default Implementation
extension ObjectManagerPossessingType {
    public static var objects: DJObjectManager<QuerySetProducedClass> {
        return DJObjectManager<QuerySetProducedClass>(withClass: QuerySetProducedClass.self)
    }
}