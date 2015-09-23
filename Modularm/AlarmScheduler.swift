//
//  AlarmScheduler.swift
//  Modularm
//
//  Created by Klein, Greg on 6/22/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class AlarmScheduler
{
   static let sharedInstance = AlarmScheduler()
   
   class func scheduleAlarm(alarm: Alarm)
   {
      let notification = UILocalNotification()
      
      notification.fireDate = alarm.fireDate
      notification.soundName = UILocalNotificationDefaultSoundName
      notification.userInfo = [NSString(string: "UUID") : alarm.identifier]
      
      var alertBody = "\(alarm.identifier)"
      if let text = alarm.message?.text
      {
         alertBody = text
      }
      notification.alertBody = alertBody
      
      print("scheduling alarm with time: " + alarm.fireDate.prettyDateString())
      UIApplication.sharedApplication().scheduleLocalNotification(notification)
   }
   
   class func unscheduleAlarm(alarm: Alarm)
   {
      for notification in UIApplication.sharedApplication().scheduledLocalNotifications!
      {
         if let userInfo = notification.userInfo, let alarmUUID = userInfo["UUID"] as? String
         {
            if alarm.identifier == alarmUUID
            {
               print("unscheduling alarm with time: " + alarm.fireDate.prettyDateString())
               UIApplication.sharedApplication().cancelLocalNotification(notification)
               break
            }
         }
      }
   }
   
   class func logCurrentScheduledNotifications()
   {
      let notifications = UIApplication.sharedApplication().scheduledLocalNotifications
      print(notifications)
   }
   
   class func alarmForUUID(uuid: String) -> Alarm?
   {
      var targetAlarm: Alarm?
      if let alarms = AlarmManager.alarms
      {
         for alarm in alarms
         {
            if alarm.identifier.characters.elementsEqual(uuid.characters)
            {
               targetAlarm = alarm
               break
            }
         }
      }
      return targetAlarm
   }
}