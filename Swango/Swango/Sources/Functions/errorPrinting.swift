//
//  errorPrinting.swift
//  Swango
//
//  Created by Jan Nash on 22/11/15.
//  Copyright © 2015 Jan Nash. All rights reserved.
//

import Foundation


func printError(error: NSError) {
    print("Error: \(error.domain) Description: \(error.localizedDescription)")
}


func printErrorFromPointer(errorPointer: NSErrorPointer) {
    print("Error: \(errorPointer.memory!.domain) Description: \(errorPointer.memory!.localizedDescription)")
}
