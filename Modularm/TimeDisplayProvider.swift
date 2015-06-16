//
//  TimeDisplayProvider.swift
//  Modularm
//
//  Created by Klein, Greg on 6/13/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation

struct TimeDisplayProvider
{
   static func textForHourValue(value: Int) -> String
   {
      var hourInt = (value + 12) % 12
      hourInt = hourInt == 0 ? 12 : hourInt
      return hourInt <= 9 ? "0\(hourInt)" : "\(hourInt)"
   }
   
   static func textForMinuteValue(value: Int) -> String
   {
      return value <= 9 ? "0\(value)" : "\(value)"
   }
}

struct AlarmCountdownUtility
{
   static func timeUntilAlarmHour(hour: Int, minute: Int) -> (hour: Int, minute: Int)
   {
      let currentDate = NSDate()
      
      let currentHourMinute = (currentDate.hour, currentDate.minute)
      let dateHourMinute = (hour, minute)
      
      var hour = dateHourMinute.0 - currentHourMinute.0
      if dateHourMinute.0 < currentHourMinute.0 {
         hour += 24
      }
      
      var minute = dateHourMinute.1 - currentHourMinute.1
      if dateHourMinute.1 < currentHourMinute.1 {
         minute += 60
         hour -= 1
      }
      
      if hour == 0 && minute == 0 {
         hour = 24
      }
      
      if hour < 0 {
         hour = 23
      }
      
      return (hour, minute)
   }
   
   static func hoursUntilAlarmDate(date: NSDate) -> Int
   {
      return self.timeUntilAlarmHour(date.hour, minute: date.minute).hour
   }
   
   static func minutesUntilAlarmDate(date: NSDate) -> Int
   {
      return self.timeUntilAlarmHour(date.hour, minute: date.minute).minute
   }
   
   static func informativeCountdownTextForHour(hour: Int, minute: Int) -> String
   {
      let time = self.timeUntilAlarmHour(hour, minute: minute)
      
      let hourWord = time.hour == 1 ? "hour" : "hours"
      let minuteWord = time.minute == 1 ? "minute" : "minutes"
      
      return "\(time.hour) \(hourWord) and \(time.minute) \(minuteWord)"
   }
   
   static func countdownTextForAlarmDate(date: NSDate) -> String
   {
      return self.informativeCountdownTextForHour(date.hour, minute: date.minute)
   }
}
