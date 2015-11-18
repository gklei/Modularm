//
//  Alarm.swift
//  Modularm
//
//  Created by Klein, Greg on 5/1/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation
import CoreData

@objc(AlarmOptionModelProtocol)
protocol AlarmOptionModelProtocol
{
   func humanReadableString() -> String
}

enum AlarmType: Int16 {
   case Date, Timer
}

@objc(Alarm)
class Alarm: NSManagedObject
{
   @NSManaged var fireDateValue: NSTimeInterval
   @NSManaged var completedSetup: Bool
   @NSManaged var active: Bool
   @NSManaged var snooze: Snooze?
   @NSManaged var countdown: Countdown?
   @NSManaged var date: Date?
   @NSManaged var message: Message?
   @NSManaged var repeatModel: Repeat?
   @NSManaged var sound: Sound?
   @NSManaged var weather: Weather?
   @NSManaged var identifier: String
   @NSManaged var alarmTypeValue: Int16
   
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
   
   var alarmType: AlarmType {
      get {
         return AlarmType(rawValue: self.alarmTypeValue)!
      }
      set {
         self.alarmTypeValue = newValue.rawValue
      }
   }
   
   override func awakeFromInsert()
   {
      super.awakeFromInsert()
      
      self.sound = CoreDataStack.newModelWithOption(.Sound) as? Sound
      self.fireDateValue = NSDate().timeIntervalSince1970
      self.identifier = NSUUID().UUIDString
      self.alarmType = .Date
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
         alarmAttribute = self.repeatModel
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
   
   func updateAlarmDate()
   {
      self.fireDate = NSDate.alarmDateWithHour(self.fireDate.hour, minute: self.fireDate.minute);
   }
}

extension Alarm: PAlarm
{
   var alarmIdentifier: String {
      return self.identifier
   }
   
   var alarmBody: String {
      return self.message?.text ?? "No message"
   }
   
   var alarmHour: Int {
      return self.fireDate.hour
   }
   
   var alarmMinute: Int {
      return self.fireDate.minute
   }
   
   var alarmWeekDays: [Int]? {
      return self.repeatModel?.intArray()
   }
   
   var alarmSound: String {
      return "AlarmSound.caf"
   }
   
   var snoozeMinute: Int {
      var minute: Int = 0
      if let duration = self.snooze?.duration {
         minute = Int(duration.rawValue)
      }
      return minute
   }
}

extension Alarm: PWeatherForecastRequestParam
{
   var time: NSDate {
      return self.fireDate
   }
}
