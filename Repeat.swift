//
//  Repeat.swift
//  Modularm
//
//  Created by Klein, Greg on 5/3/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation
import CoreData

enum RepeatDay
{
   case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
}

@objc(Repeat)
class Repeat: NSManagedObject
{
   private var mutableDaySet = Set<RepeatDay>()
   
   @NSManaged var dayArray: AnyObject
   @NSManaged var alarm: Alarm
   
   func addDay(day: RepeatDay)
   {
      if !self.mutableDaySet.contains(day)
      {
         self.mutableDaySet.insert(day)
      }
   }
   
   func removeDay(day: RepeatDay)
   {
      self.mutableDaySet.remove(day)
   }
}
