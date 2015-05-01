//
//  Repeat.swift
//  Modularm
//
//  Created by Klein, Greg on 5/1/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation
import CoreData

@objc(Repeat)
class Repeat: NSManagedObject
{
   @NSManaged var dayMask: Int16
   @NSManaged var alarm: Alarm   
}
