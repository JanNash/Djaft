//
//  Zoo+CoreDataProperties.swift
//  
//
//  Created by Jan Nash on 3/10/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Zoo {

    @NSManaged var name: String?
    @NSManaged var animals: NSSet?
    @NSManaged var enclosures: NSSet?
    @NSManaged var visitors: NSSet?

}
