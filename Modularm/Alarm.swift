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
   @NSManaged var completedSetup: Bool
   @NSManaged var snooze: Snooze?
   @NSManaged var countdown: Countdown?
   @NSManaged var date: Date?
   @NSManaged var message: Message?
   @NSManaged var repeat: Repeat?
   @NSManaged var sound: Sound?
   @NSManaged var weather: Weather?
   
   var isValid: Bool {
      get {
         return self.fireDate != 0
      }
   }
   
   override func awakeFromInsert()
   {
      self.completedSetup = false
   }
}
