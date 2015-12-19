//
//  SWManagedObject.swift
//  Swango
//
//  Created by Jan Nash on 25/10/15.
//  Copyright © 2015 Jan Nash. All rights reserved.
//

import Foundation
import CoreData


// MARK: Public Interface
public extension SWManagedObject {
    // Computed Class Properties
    public static var objects: SWObjectManager {
        return self._objectManager
    }
    
    // Instance Functions
    public func save() {
        self._save()
    }
}


// MARK: Main Implementation
public class SWManagedObject: NSManagedObject {
    // Object Manager
    private static var __objectManager: SWObjectManager!
    
    // Property Names (For giving better error messages on erratic predicate strings)
    private static var __propertyNames: [String]!
}


// MARK: Private Computed Static Properties
private extension SWManagedObject {
    private static var _objectManager: SWObjectManager {
        if self.__objectManager == nil {
            self.__objectManager = SWObjectManager(withClass: self)
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
private extension SWManagedObject {
    private func _save() {
        do {
            try self.managedObjectContext?.save()
        } catch let error as NSError {
            printError(error)
        }
    }
}


