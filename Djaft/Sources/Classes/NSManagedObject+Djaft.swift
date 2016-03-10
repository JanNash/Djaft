//
//  NSManagedObject+Djaft.swift
//  Djaft
//
//  Created by Jan Nash on 25/10/15.
//  Copyright © 2015 Jan Nash. All rights reserved.
//

import Foundation
import CoreData


// MARK: Public Interface
public extension NSManagedObject {
    // Computed Class Properties
    public static var objects: DJObjectManager {
        return self._objectManager
    }
    
    // Class Default Properties
    public static var defaultOrderBys: [String] {
        get              {return self._defaultOrderBys}
        set(newOrderBys) {self._defaultOrderBys = newOrderBys}
    }
    
    // Instance Functions
    public func save() {
        self._save()
    }
}


// MARK: Main Implementation
private extension NSManagedObject {
    // Object Manager
    private static var __objectManager: DJObjectManager!
    
    // Ordering
    private static var _defaultOrderBys: [String] = []
    
    // Property Names (For giving better error messages on erratic predicate strings)
    private static var __propertyNames: [String]!
}


// MARK: Private Computed Static Properties
private extension NSManagedObject {
    private static var _objectManager: DJObjectManager {
        if self.__objectManager == nil {
            self.__objectManager = DJObjectManager(withClass: self)
        }
        return self.__objectManager
    }
    
    private static var _propertyNames: [String] {
        // Thanks derpturkey
        // http://derpturkey.com/get-property-names-of-object-in-swift/
        var results: [String] = [];
        
        // retrieve the properties via the class_copyPropertyList function
        var count: UInt32 = 0;
        let myClass: AnyClass = self;
        let properties = class_copyPropertyList(myClass, &count);
        
        // iterate each objc_property_t struct
        for var i: UInt32 = 0; i < count; i++ {
            let property = properties[Int(i)];
            
            // retrieve the property name by calling property_getName function
            let cname = property_getName(property);
            
            // convert the c string into a Swift string
            let name = String.fromCString(cname);
            results.append(name!);
        }

        // release objc_property_t structs
        free(properties);
        return results;
    }
}

    
// MARK: Private Instance Functions
private extension NSManagedObject {
    private func _save() {
        do {
            try self.managedObjectContext?.save()
        } catch let error as NSError {
            printError(error)
        }
    }
}

