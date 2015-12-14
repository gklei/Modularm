//
//  Alarm.swift
//  Modularm
//
//  Created by Klein, Greg on 5/1/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation
import CoreData

enum AlarmType: Int {
   case Alert, Reminder
}

@objc(AlarmOptionModelProtocol)
protocol AlarmOptionModelProtocol
{
   func humanReadableString() -> String
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
   
   var alarmType: AlarmType {
      get {
         return AlarmType(rawValue: Int(self.alarmTypeValue))!
      }
      set {
         alarmTypeValue = Int16(newValue.rawValue)
      }
   }
   
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
      super.awakeFromInsert()
      
      self.sound = CoreDataStack.newModelWithOption(.Sound) as? Sound
      self.snooze = CoreDataStack.newModelWithOption(.Snooze) as? Snooze
      
      // make default alarm schedule for 30 minutes from now
      self.fireDateValue = NSDate().dateByAddingTimeInterval(60 * 30).timeIntervalSince1970
      
      self.identifier = NSUUID().UUIDString
      self.completedSetup = false
      alarmType = .Reminder
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
   
   func updateWeatherInfo()
   {
      if let weather = self.weather
      {
         WeatherForecastAPI.requestFor(self, callback: { (result:PWeatherForecastResult?, error:ErrorType?) -> () in
            if let forecastResult = result
            {
               weather.readableTextSummary = forecastResult.readableTextSummary
               weather.fahrenheitTemperature = forecastResult.temperature.f
               CoreDataStack.save()
            }
         })
      }
   }
   
   func updateAlarmDate()
   {
      self.fireDate = NSDate.alarmDateWithHour(self.fireDate.hour, minute: self.fireDate.minute);
   }
   
   func optionIsEnabled(option: AlarmOption) -> Bool
   {
      var enabled = false
      switch option
      {
      case .Countdown:
         if let _ = self.countdown {
            enabled = true
         }
         break
      case .Date:
         if let _ = self.date {
            enabled = true
         }
         break
      case .Music:
         if let soundModel = self.sound {
            enabled = soundModel.gradual
         }
         break
      case .Repeat:
         if let _ = self.repeatModel {
            enabled = true
         }
         break
      case .Snooze:
         if let _ = self.snooze {
            enabled = true
         }
         break
      case .Sound:
         if let _ = self.sound {
            enabled = true
         }
         break
      case .Weather:
         if let _ = self.weather {
            enabled = true
         }
         break
      case .Message:
         if let _ = self.message {
            enabled = true
         }
         break
      default:
         break
      }
      return enabled
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
      // Used for UILocalNotification
      return self.sound!.alarmSound!.nameInMainBundle
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
