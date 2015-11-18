//
//  PAlarmExtension.swift
//  Modularm
//
//  Created by Alex Hong on 11/11/2015.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation

// MARK: - PAlarm Extension
// This extension is for check alarm property
extension PAlarm {
   private var isEveryDayAlarm : Bool{
      return (alarmWeekDays?.count ?? 0) == 7
   }
   
   private var isOnceAlarm : Bool {
      return alarmWeekDays == nil || (alarmWeekDays?.count ?? 0) == 0
   }
   
   var isSnoozeEnabled : Bool {
      return snoozeMinute > 0
   }
}

func ==(rhs:PAlarm, lhs:PAlarm) -> Bool{
   return rhs.alarmIdentifier == lhs.alarmIdentifier
}

// MARK: - PAlarm Extension for building notifications
extension PAlarm
{
   func buildNotifications() -> [UILocalNotification] {
      if isEveryDayAlarm || isOnceAlarm{
         let notification = buildTemplateNotification(nextFireDate())
         //let alarm repeat everyday
         if isEveryDayAlarm{
            notification.repeatInterval = .Day
         }
         return [notification]
      }
      
      guard let weekDays = alarmWeekDays else {
         fatalError("PAlarm:buildNotification ->  Should not be happened")
      }
      
      var result:[UILocalNotification] = []
      for day in weekDays {
         let notification = buildTemplateNotification(nextFireDate(day))
         notification.repeatInterval = .Weekday
         result.append(notification)
      }
      return result
   }
   
   // This function builds template notification with fire date.
   func buildTemplateNotification(fireDate:NSDate) -> UILocalNotification{
      let notification = UILocalNotification()
      notification.alertBody = alarmBody
      notification.soundName = alarmSound
      notification.fireDate = fireDate
      notification.category = isSnoozeEnabled ? kAlarmNotificationSnoozeCategoryIdentifier : nil
      notification.userInfo = [kAlarmNotificationUserInfoAlarmUUIDKey:alarmIdentifier, kAlarmNotificationUserInfoSnoozeMinute:snoozeMinute]
      return notification
   }
   
   private func nextFireDate() -> NSDate {
      let now = NSDate()
      let date = now.changedHour(alarmHour, minute: alarmMinute)
      return date < now ? date.nextDay() : date
   }
   
   private func nextFireDate(weekDay:Int) -> NSDate{
      let now = NSDate()
      var date = now.changedHour(alarmHour, minute: alarmMinute)
      
      //If already passed today
      if date < now{
         date = date.nextDay()
      }
      
      //repeat until weekDay is equal
      while (weekDay != date.dayOfWeek()){
         date = date.nextDay()
      }
      return date
   }
}