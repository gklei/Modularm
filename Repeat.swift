//
//  Repeat.swift
//  Modularm
//
//  Created by Klein, Greg on 5/3/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation
import CoreData

class Repeat: NSManagedObject
{
    @NSManaged var dayArray: AnyObject
    @NSManaged var alarm: Alarm
}
