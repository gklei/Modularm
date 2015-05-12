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
   @NSManaged var fireDateValue: NSTimeInterval
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
         return self.fireDateValue != 0
      }
   }
   
   var fireDate: NSDate {
      get {
         return NSDate(timeIntervalSince1970: self.fireDateValue)
      }
      set {
         self.fireDateValue = newValue.timeIntervalSince1970
      }
   }
   
   override func awakeFromInsert()
   {
      self.completedSetup = false
      self.sound = CoreDataStack.newModelWithOption(.Sound) as? Sound
      self.fireDateValue = NSDate().timeIntervalSince1970
   }
   
   func deleteOption(option: AlarmOption)
   {
      var alarmAttribute: NSManagedObject?
      switch option
      {
      case .Countdown:
         alarmAttribute = self.countdown
         break
      case .Date:
         alarmAttribute = self.date
         break
      case .Message:
         alarmAttribute = self.message
         break
      case .Music:
         return
      case .Repeat:
         alarmAttribute = self.repeat
         break
      case .Snooze:
         alarmAttribute = self.snooze
         break
      case .Sound:
         alarmAttribute = self.sound
         break
      case .Weather:
         alarmAttribute = self.weather
         break
      case .Unknown:
         return
      }
      
      CoreDataStack.deleteObject(alarmAttribute)
      CoreDataStack.save()
   }
}
