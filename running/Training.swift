//
//  Training.swift
//  running
//
//  Created by Developer on 18/04/2015.
//  Copyright (c) 2015 Developer. All rights reserved.
//

import Foundation
import CoreData

class Training: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var duration: String
    @NSManaged var distance: String
    @NSManaged var speed: String
    @NSManaged var locations: NSOrderedSet

}
