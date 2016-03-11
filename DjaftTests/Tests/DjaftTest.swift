//
//  DjaftTest.swift
//  DjaftTests
//
//  Created by Jan Nash on 12/19/15.
//  Copyright © 2015 Jan Nash. All rights reserved.
//

import XCTest
import CoreData
@testable import Djaft

class DjaftTest: XCTestCase {
    
    var mockContext: NSManagedObjectContext = CoreDataMockSetup.createObjectContext()
    
    func testFatalErrorWhenNoObjectContext() {
        self.expectFatalError() {
            let _:NSManagedObject = NSManagedObject.objects.create()
        }
    }
    
}
