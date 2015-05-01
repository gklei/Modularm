//
//  Alarm.swift
//  Modularm
//
//  Created by Klein, Greg on 5/1/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation
import CoreData

@objc(Alarm)
class Alarm: NSManagedObject
{
   @NSManaged var fireDate: NSTimeInterval
   @NSManaged var snooze: Snooze
   @NSManaged var countdown: NSManagedObject
   @NSManaged var date: Date
   @NSManaged var message: NSManagedObject
   @NSManaged var repeat: NSManagedObject
   @NSManaged var sound: Sound
   @NSManaged var weather: NSManagedObject
   
   override func awakeFromInsert()
   {
      self.fireDate = NSDate().timeIntervalSince1970
   }
}
