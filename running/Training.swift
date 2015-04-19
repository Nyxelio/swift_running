//
//  Training.swift
//  running
//
//  Created by Developer on 19/04/2015.
//  Copyright (c) 2015 Developer. All rights reserved.
//

import Foundation
import CoreData

class Training: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var distance: String
    @NSManaged var duration: String
    @NSManaged var speed: String
    @NSManaged var maxspeed: String
    @NSManaged var locations: NSOrderedSet

}
