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
      
      if let uuid = alarm.identifier {
         notification.userInfo = [NSString(string: "UUID") : uuid]
         notification.alertBody = "\(alarm.identifier)"
      } else {
         notification.alertBody = "No UUID for Alarm"
      }
      
      UIApplication.sharedApplication().scheduleLocalNotification(notification)
   }
   
   class func logCurrentScheduledNotifications()
   {
      let notifications = UIApplication.sharedApplication().scheduledLocalNotifications
      println(notifications)
   }
}
