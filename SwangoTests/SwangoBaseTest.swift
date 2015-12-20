//
//  SwangoTest.swift
//  SwangoTests
//
//  Created by Jan Nash on 12/19/15.
//  Copyright © 2015 Jan Nash. All rights reserved.
//

import XCTest
import CoreData
@testable import Swango

internal class SwangoTest: XCTestCase {
    var mainObjectContext: NSManagedObjectContext = CoreDataMockSetup.createObjectContext()
}
